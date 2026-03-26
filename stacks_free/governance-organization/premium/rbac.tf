# ============================================================
# AETHRONOPS v2 — RBAC
# Pattern  : governance-organization / premium
# Tier     : premium
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : CUSTOM-RBAC-DEFINITIONS
# Resource :  (native azurerm)
# CAF : SEC-1, GOV-1
# MCSB : PA-7, IM-1
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-privileged-access
# RGPD : ART-25, ART-32
# NIS2 : ART-21-2i
# ──────────────────────────────────────────────────────────
resource "azurerm_role_definition" "aethronops_landing_zone_owner" {
  name        = "AethronOps Landing Zone Owner"
  scope       = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  description = "Proprietaire de Landing Zone — droits Contributor + UserAccessAdmin sur RG"

  permissions {
    actions     = ["*"]
    not_actions = ["Microsoft.Authorization/*/Delete", "Microsoft.Authorization/elevateAccess/Action"]
  }

  assignable_scopes = ["/subscriptions/${data.azurerm_client_config.current.subscription_id}"]
}

resource "azurerm_role_definition" "aethronops_security_reader" {
  name        = "AethronOps Security Reader"
  scope       = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  description = "Lecteur sécurité — logs + policies en lecture seule"

  permissions {
    actions     = ["*/read", "Microsoft.Security/*/read", "Microsoft.PolicyInsights/*/read"]
    not_actions = []
  }

  assignable_scopes = ["/subscriptions/${data.azurerm_client_config.current.subscription_id}"]
}

