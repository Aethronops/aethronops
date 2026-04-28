# ============================================================
# AETHRONOPS v3 — WIRING
# Pattern  : app-service-mongodb / dev
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
# Database connection string stored in Key Vault
# Referenced by App Service via @Microsoft.KeyVault()
# ──────────────────────────────────────────────────────────
# MongoDB connection string (mongodb+srv format with private endpoint FQDN)
resource "azurerm_key_vault_secret" "database_url" {
  name            = "${var.project_name}-database-url"
  value           = "mongodb+srv://${var.mongodb_admin_login}:${urlencode(random_password.mongo_admin.result)}@${module.mongo_cluster.mongo_cluster_name}.mongocluster.cosmos.azure.com/${var.project_name}?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000"
  key_vault_id    = module.key_vault.resource_id
  content_type    = "text/plain"
  expiration_date = timeadd(timestamp(), "8760h") # 1 year rotation

  depends_on = [module.key_vault, azurerm_role_assignment.mi_keyvault_secrets]

  lifecycle { ignore_changes = [expiration_date] }
}

# Separate secret for the admin password (rotation + debugging)
resource "azurerm_key_vault_secret" "db_admin_password" {
  name            = "${var.project_name}-db-admin-password"
  value           = random_password.mongo_admin.result
  key_vault_id    = module.key_vault.resource_id
  content_type    = "text/plain"
  expiration_date = timeadd(timestamp(), "8760h")

  depends_on = [module.key_vault, azurerm_role_assignment.mi_keyvault_secrets]

  lifecycle { ignore_changes = [expiration_date] }
}
