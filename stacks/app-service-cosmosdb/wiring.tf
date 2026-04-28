# ============================================================
# AETHRONOPS v3 — WIRING
# Pattern  : app-service-cosmosdb / dev
# Tier     : dev
# ============================================================
# Auto-generated connections between bricks.
# Key Vault secrets, role assignments, diagnostic settings.
# ============================================================

# ──────────────────────────────────────────────────────────
# RBAC: Managed Identity → Key Vault (Secrets User)
# AVM Key Vault defaults to RBAC mode — access policies
# are NOT supported. Uses role assignment instead.
# ──────────────────────────────────────────────────────────
resource "azurerm_role_assignment" "mi_keyvault_secrets" {
  scope                = module.key_vault.resource_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.managed_identity.principal_id
  principal_type       = "ServicePrincipal"
  lifecycle { ignore_changes = [principal_type] }
}

# ──────────────────────────────────────────────────────────
# RBAC: App Service System Identity → Key Vault (Secrets User)
# Required for @Microsoft.KeyVault() references in app settings.
# ──────────────────────────────────────────────────────────
resource "azurerm_role_assignment" "app_keyvault_secrets" {
  scope                = module.key_vault.resource_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.app_service.system_assigned_mi_principal_id
  principal_type       = "ServicePrincipal"
  lifecycle { ignore_changes = [principal_type] }
}


# ──────────────────────────────────────────────────────────
# Role assignment: Managed Identity → Cosmos DB
# Cosmos DB uses its OWN RBAC system, NOT azurerm_role_assignment.
# Built-in 'Cosmos DB Built-in Data Contributor' role.
# ──────────────────────────────────────────────────────────
resource "azurerm_cosmosdb_sql_role_assignment" "mi_cosmos" {
  resource_group_name = module.resource_group.name
  account_name        = module.cosmosdb_baseline.name
  role_definition_id  = "${module.cosmosdb_baseline.resource_id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  principal_id        = module.managed_identity.principal_id
  scope               = module.cosmosdb_baseline.resource_id
}

# ──────────────────────────────────────────────────────────
# Cosmos DB endpoint stored in Key Vault
# Endpoint only — no connection string (RBAC + MI auth).
# ──────────────────────────────────────────────────────────
resource "azurerm_key_vault_secret" "cosmosdb_endpoint" {
  name            = "${var.project_name}-cosmosdb-endpoint"
  value           = module.cosmosdb_baseline.endpoint
  key_vault_id    = module.key_vault.resource_id
  content_type    = "text/plain"
  expiration_date = timeadd(timestamp(), "8760h")

  depends_on = [module.key_vault, azurerm_role_assignment.mi_keyvault_secrets]

  lifecycle { ignore_changes = [expiration_date] }
}
