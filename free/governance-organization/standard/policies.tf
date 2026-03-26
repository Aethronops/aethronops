# ============================================================
# AETHRONOPS v2 — POLICIES
# Pattern  : governance-organization / standard
# Tier     : standard
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
  enforce              = true

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
  enforce              = true

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
  enforce              = true
}

resource "azurerm_management_group_policy_assignment" "enforce_tls" {
  name                 = "ao-tls-version"
  display_name         = "AethronOps — Enforce TLS 1.2"
  management_group_id  = local.governance_scope_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/f0e6e85b-9b9f-4a4b-b67b-f730d42f1b0b"
  enforce              = true
}

resource "azurerm_management_group_policy_assignment" "deny_public_ip" {
  name                 = "ao-deny-public-ip"
  display_name         = "AethronOps — Deny Public IP"
  management_group_id  = local.governance_scope_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  enforce              = true
}


# ──────────────────────────────────────────────────────────
# BRICK : POLICY-INITIATIVES
# Resource :  (native azurerm)
# CAF : GOV-2
# MCSB : PV-1, GS-5
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-posture-vulnerability-management
# RGPD : ART-25
# NIS2 : ART-21-2a
# ──────────────────────────────────────────────────────────
# ──────────────────────────────────────────────────────────
# Microsoft Built-in Policy Initiatives
# Assigned at Management Group scope — inherited by all subscriptions
# ──────────────────────────────────────────────────────────

resource "azurerm_management_group_policy_assignment" "mcsb" {
  name                 = "ao-mcsb"
  display_name         = "AethronOps — Microsoft Cloud Security Benchmark (MCSB)"
  management_group_id  = azurerm_management_group.management_group.id
  policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8"
  enforce              = true
}

resource "azurerm_management_group_policy_assignment" "cis_v2" {
  name                 = "ao-cis_v2"
  display_name         = "AethronOps — CIS Microsoft Azure Foundations Benchmark v2.0.0"
  management_group_id  = azurerm_management_group.management_group.id
  policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/06f19060-9e68-4070-92ca-f15cc126059e"
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
# Policy Assignments — enforcement_mode: Default
# Custom policies assigned via policy-definitions block above
# Built-in initiatives assigned via policy-initiatives block above

# ──────────────────────────────────────────────────────────
# BRICK : POLICY-EXEMPTIONS
# Resource :  (native azurerm)
# CAF : GOV-2
# MCSB : PV-2
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-posture-vulnerability-management
# RGPD : ART-30
# NIS2 : ART-21-2f
# ──────────────────────────────────────────────────────────
resource "azurerm_management_group_policy_exemption" "sandbox" {
  count                = var.enable_sandbox_exemption ? 1 : 0
  name                 = "ao-sandbox-exemption"
  display_name         = "Sandbox MG exemption"
  management_group_id  = azurerm_management_group.management_group.id
  policy_assignment_id = azurerm_management_group_policy_assignment.allowed_locations.id
  exemption_category   = "Waiver"
}
