# ============================================================
# AETHRONOPS v2 — RBAC
# Pattern  : governance-subscription / premium
# Tier     : premium
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : RBAC-ASSIGNMENTS
# Resource :  (native azurerm)
# CAF : SEC-1, GOV-1
# MCSB : PA-7, IM-1
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-privileged-access
# RGPD : ART-25, ART-32
# NIS2 : ART-21-2i
# ──────────────────────────────────────────────────────────
resource "azurerm_role_assignment" "reader" {
  count                = var.rbac_reader_group_id != "" ? 1 : 0
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = var.rbac_reader_group_id
}

resource "azurerm_role_assignment" "contributor" {
  count                = var.rbac_contributor_group_id != "" ? 1 : 0
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = var.rbac_contributor_group_id
}

resource "azurerm_role_assignment" "owner" {
  count                = var.rbac_owner_group_id != "" ? 1 : 0
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Owner"
  principal_id         = var.rbac_owner_group_id
}

resource "azurerm_role_assignment" "security_reader" {
  count                = var.rbac_security_reader_group_id != "" ? 1 : 0
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Security Reader"
  principal_id         = var.rbac_security_reader_group_id
}

