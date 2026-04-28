# ============================================================
# AETHRONOPS v3 — DB ALERTS
# ============================================================
# Azure Recommended Alerts 2026 — OR Defender for Cloud covers
# anomaly detection with ML. These alerts are the "infrastructure"
# layer (CPU/storage/connections), Defender is the "attack" layer.
# ============================================================

# Action Group — where alerts are sent
resource "azurerm_monitor_action_group" "db_alerts" {
  count               = var.enable_recommended_db_alerts && length(var.budget_alert_emails) > 0 ? 1 : 0
  name                = "ag-db-alerts-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  short_name          = "dbalerts"

  dynamic "email_receiver" {
    for_each = toset(var.budget_alert_emails)
    content {
      name          = "email-${replace(replace(email_receiver.value, "@", "-at-"), ".", "-")}"
      email_address = email_receiver.value
    }
  }

  tags = local.common_tags
}

locals {
  db_alerts_enabled         = var.enable_recommended_db_alerts && length(var.budget_alert_emails) > 0 ? 1 : 0
  db_alerts_action_group_id = local.db_alerts_enabled == 1 ? azurerm_monitor_action_group.db_alerts[0].id : null
}

# CPU > 80%
resource "azurerm_monitor_metric_alert" "sql_cpu_percent" {
  count               = local.db_alerts_enabled
  name                = "alert-sql-cpu-percent-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  scopes              = [format("%s/databases/sqldb-%s", module.sql_database.resource_id, var.project_name)]
  description         = "CPU > 80%"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.Sql/servers/databases"
    metric_name      = "cpu_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = local.db_alerts_action_group_id
  }

  tags = local.common_tags
}

# Storage > 85%
resource "azurerm_monitor_metric_alert" "sql_storage_percent" {
  count               = local.db_alerts_enabled
  name                = "alert-sql-storage-percent-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  scopes              = [format("%s/databases/sqldb-%s", module.sql_database.resource_id, var.project_name)]
  description         = "Storage > 85%"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.Sql/servers/databases"
    metric_name      = "storage_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 85
  }

  action {
    action_group_id = local.db_alerts_action_group_id
  }

  tags = local.common_tags
}

# Log IO > 80%
resource "azurerm_monitor_metric_alert" "sql_log_write_percent" {
  count               = local.db_alerts_enabled
  name                = "alert-sql-log-write-percent-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  scopes              = [format("%s/databases/sqldb-%s", module.sql_database.resource_id, var.project_name)]
  description         = "Log IO > 80%"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.Sql/servers/databases"
    metric_name      = "log_write_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = local.db_alerts_action_group_id
  }

  tags = local.common_tags
}

