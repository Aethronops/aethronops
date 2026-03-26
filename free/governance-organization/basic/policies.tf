# ============================================================
# AETHRONOPS v2 — POLICIES
# Pattern  : governance-organization / basic
# Tier     : basic
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : POLICY-DEFINITIONS
# Resource :  (native azurerm)
# CAF : GOV-2, SEC-1
# MCSB : PV-1, PV-2, AM-2, NS-8, DP-3
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-posture-vulnerability-management
# RGPD : ART-25, ART-32
# NIS2 : ART-21-2a, ART-21-2f
# ──────────────────────────────────────────────────────────
# ──────────────────────────────────────────────────────────
# Azure Policy Definitions — parametrables via variables
# ──────────────────────────────────────────────────────────

resource "azurerm_management_group_policy_assignment" "allowed_locations" {
  name                 = "ao-allowed-locations"
  display_name         = "AethronOps — Allowed Locations"
  management_group_id  = local.governance_scope_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
  enforce              = false

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = var.allowed_locations
    }
  })
}

resource "azurerm_management_group_policy_assignment" "require_tags" {
  name                 = "ao-require-tags"
  display_name         = "AethronOps — Require Tags"
  management_group_id  = local.governance_scope_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
  enforce              = false

  parameters = jsonencode({
    tagName = {
      value = var.required_tags[0]
    }
  })
}

resource "azurerm_management_group_policy_assignment" "enforce_https_storage" {
  name                 = "ao-https-storage"
  display_name         = "AethronOps — Enforce HTTPS on Storage"
  management_group_id  = local.governance_scope_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9"
  enforce              = false
}

resource "azurerm_management_group_policy_assignment" "enforce_tls" {
  name                 = "ao-tls-version"
  display_name         = "AethronOps — Enforce TLS 1.2"
  management_group_id  = local.governance_scope_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/f0e6e85b-9b9f-4a4b-b67b-f730d42f1b0b"
  enforce              = false
}


# ──────────────────────────────────────────────────────────
# BRICK : POLICY-ASSIGNMENTS
# Resource :  (native azurerm)
# CAF : GOV-2, SEC-1
# MCSB : PV-2, GS-5
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-posture-vulnerability-management
# RGPD : ART-25, ART-32
# NIS2 : ART-21-2a, ART-21-2f
# ──────────────────────────────────────────────────────────
# Policy Assignments — enforcement_mode: DoNotEnforce
# Custom policies assigned via policy-definitions block above
# Built-in initiatives assigned via policy-initiatives block above
