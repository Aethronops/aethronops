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

