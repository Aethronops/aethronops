# ============================================================
# AETHRONOPS v3 — WIRING
# Pattern  : container-apps-sql / dev
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

# ──────────────────────────────────────────────────────────
# Database connection string stored in Key Vault
# Referenced by App Service via @Microsoft.KeyVault()
# ──────────────────────────────────────────────────────────
resource "azurerm_key_vault_secret" "database_url" {
  name            = "${var.project_name}-database-url"
  value           = "Server=tcp:${module.sql_database.resource.fully_qualified_domain_name},1433;Database=sqldb-${var.project_name};Authentication=Active Directory Managed Identity;Encrypt=yes;TrustServerCertificate=no;"
  key_vault_id    = module.key_vault.resource_id
  content_type    = "text/plain"
  expiration_date = timeadd(timestamp(), "8760h") # 1 year rotation

  depends_on = [module.key_vault, azurerm_role_assignment.mi_keyvault_secrets]

  lifecycle { ignore_changes = [expiration_date] }
}
