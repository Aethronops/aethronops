# ============================================================
# AETHRONOPS v2 — WIRING
# Pattern  : platform-management / basic
# Tier     : basic
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
}

# ──────────────────────────────────────────────────────────
# Role assignment: Managed Identity → Storage Account
# Allows passwordless access to blob storage.
# ──────────────────────────────────────────────────────────
resource "azurerm_role_assignment" "mi_storage_blob" {
  scope                = module.storage_account.resource_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.managed_identity.principal_id
}
