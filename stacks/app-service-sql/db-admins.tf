# ============================================================
# AETHRONOPS v3 — DB ADMINS ENTRA GROUP
# ============================================================
# Microsoft CAF 2026 : DB admin = Entra *group* (not a MI).
# Lets human operators connect with their own Entra identity
# and membership is managed centrally without touching the DB.
# ============================================================

# The admin group itself. Owned by the current deploy principal.
resource "azuread_group" "db_admins" {
  count            = var.enable_db_passwordless ? 1 : 0
  display_name     = coalesce(var.db_admin_group_name, "db-admins-${local.name_prefix}-${random_string.storage_suffix.result}")
  security_enabled = true
  owners           = [data.azurerm_client_config.current.object_id]
}

# Wait 3 minutes for the new Managed Identity to propagate from Azure
# Resource Manager to Microsoft Entra Graph. Without this, the next
# `azuread_group_member` call silently records a reference to a not-yet-
# resolved directory object → the MI never appears as an active group
# member → the app cannot authenticate to the DB with passwordless Entra.
# Microsoft documents 5-10 min as safe; 3 min is a pragmatic compromise.
resource "time_sleep" "wait_mi_graph_propagation" {
  count           = var.enable_db_passwordless ? 1 : 0
  create_duration = "180s"
  depends_on      = [module.managed_identity]
}

# App Service Managed Identity is always a member (app passwordless access).
resource "azuread_group_member" "db_admin_mi" {
  count            = var.enable_db_passwordless ? 1 : 0
  group_object_id  = azuread_group.db_admins[0].object_id
  member_object_id = module.managed_identity.principal_id
  depends_on       = [time_sleep.wait_mi_graph_propagation]
}

# Extra operators (humans, groups, SPs) declared in tfvars.
resource "azuread_group_member" "db_admin_extra" {
  for_each         = var.enable_db_passwordless ? toset(var.db_admin_members) : toset([])
  group_object_id  = azuread_group.db_admins[0].object_id
  member_object_id = each.value
}

# ──────────────────────────────────────────────────────────
# SQL Automatic Tuning (2026 Azure best practice, free).
# Uses azapi_resource_action with method=PATCH because
# automaticTuning/current is a singleton subresource —
# azapi_update_resource sends PUT which Azure rejects with
# 405 MethodNotAllowed on this endpoint.
# FORCE_LAST_GOOD_PLAN fixes plan regressions automatically.
# CREATE_INDEX / DROP_INDEX adjust indexes based on live usage.
# ──────────────────────────────────────────────────────────
resource "azapi_resource_action" "sql_auto_tuning" {
  count       = var.sql_automatic_tuning_enabled ? 1 : 0
  type        = "Microsoft.Sql/servers/databases/automaticTuning@2024-05-01-preview"
  resource_id = "${module.sql_database.resource_id}/databases/sqldb-${var.project_name}/automaticTuning/current"
  method      = "PATCH"
  body = {
    properties = {
      desiredState = "Auto"
      options = {
        createIndex       = { desiredState = "On" }
        dropIndex         = { desiredState = "On" }
        forceLastGoodPlan = { desiredState = "On" }
      }
    }
  }
  # The implicit dependency on module.sql_database resolves to the
  # server only; the database is created inside a sub-module and
  # is not visible to terraform's DAG from the server resource_id.
  # Without this explicit depends_on, the PATCH runs before the
  # database exists and Azure returns 404 ParentResourceNotFound.
  depends_on = [module.sql_database]
}

# ──────────────────────────────────────────────────────────
# SQL Server Auditing → Log Analytics (NIS2 Art.21(2)(b),
# DORA Art.13, ISO 27001 A.8.15, SOC 2 CC7.2).
# log_monitoring_enabled = true tells Azure to forward audit
# events to whichever Log Analytics workspace is targeted by
# the database's diagnostic_setting with the
# SQLSecurityAuditEvents category enabled.
# ──────────────────────────────────────────────────────────
resource "azurerm_mssql_server_extended_auditing_policy" "sql_audit" {
  server_id              = module.sql_database.resource_id
  log_monitoring_enabled = true
  retention_in_days      = 90
  depends_on             = [module.sql_database]
}

# Database-level diagnostic setting capturing audit + insight logs.
# The wiring.tf default diag_sql_database targets the SERVER and
# emits AllMetrics only (server-level supports no allLogs group).
# This setting targets the actual DATABASE which exposes the
# SQLSecurityAuditEvents + SQLInsights + DevOpsOperationsAudit
# log categories required for compliance evidence.
resource "azurerm_monitor_diagnostic_setting" "sql_database_logs" {
  name                       = trimsuffix(substr("diag-sqldb-${local.name_prefix}", 0, 90), "-")
  target_resource_id         = "${module.sql_database.resource_id}/databases/sqldb-${var.project_name}"
  log_analytics_workspace_id = module.log_analytics.resource_id

  enabled_log { category = "SQLSecurityAuditEvents" }
  enabled_log { category = "DevOpsOperationsAudit" }
  enabled_log { category = "SQLInsights" }
  enabled_log { category = "AutomaticTuning" }
  enabled_log { category = "Errors" }
  enabled_log { category = "Timeouts" }
  enabled_log { category = "Blocks" }
  enabled_log { category = "Deadlocks" }

  enabled_metric { category = "AllMetrics" }

  depends_on = [module.sql_database, azurerm_mssql_server_extended_auditing_policy.sql_audit]
}

