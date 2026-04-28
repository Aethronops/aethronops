# ============================================================
# AETHRONOPS v3 — WIRING
# Pattern  : app-service-postgresql / dev
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
# ──────────────────────────────────────────────────────────
# Database creation — must exist before connection string
# ──────────────────────────────────────────────────────────
locals {
  db_name = var.database_name != "" ? var.database_name : var.project_name
  # Connection string: passwordless uses MI token (empty password),
  # legacy uses admin password from random_password resource
  pg_connection_string = try(var.enable_db_passwordless, false) ? (
    "postgresql://${module.managed_identity.resource_name}@${module.postgresql_flexible.fqdn}:5432/${local.db_name}?sslmode=require&auth-mode=managed-identity"
    ) : (
    "postgresql://${var.postgresql_admin_login}:${urlencode(random_password.pg_admin.result)}@${module.postgresql_flexible.fqdn}:5432/${local.db_name}?sslmode=require"
  )
}

resource "azurerm_postgresql_flexible_server_database" "app" {
  name      = local.db_name
  server_id = module.postgresql_flexible.resource_id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "azurerm_key_vault_secret" "database_url" {
  name            = "${var.project_name}-database-url"
  value           = local.pg_connection_string
  key_vault_id    = module.key_vault.resource_id
  content_type    = "text/plain"
  expiration_date = timeadd(timestamp(), "8760h") # 1 year rotation

  depends_on = [module.key_vault, azurerm_role_assignment.mi_keyvault_secrets]

  lifecycle { ignore_changes = [expiration_date] }
}

# Separate secret for the password alone (rotation + debugging)
resource "azurerm_key_vault_secret" "db_admin_password" {
  name            = "${var.project_name}-db-admin-password"
  value           = random_password.pg_admin.result
  key_vault_id    = module.key_vault.resource_id
  content_type    = "text/plain"
  expiration_date = timeadd(timestamp(), "8760h")

  depends_on = [module.key_vault, azurerm_role_assignment.mi_keyvault_secrets]

  lifecycle { ignore_changes = [expiration_date] }
}
