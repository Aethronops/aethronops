# ============================================================
# AETHRONOPS v2 — ENTERPRISE GOVERNANCE
# Pattern  : governance-subscription / standard
# Tier     : standard
# ============================================================
# Resource locks, immutable audit storage, rotation policies.
# Aligned with: ISO 27001 A.8.3, CIS Azure 1.3/3.1, SOC 2 CC6.1,
#               ANSSI PGSSI-S, DORA Art.12, NIS2 Art.21(2)(e)
# ============================================================

# ──────────────────────────────────────────────────────────
# RESOURCE LOCK — Prevent accidental deletion (ISO 27001 A.8.3)
# Remove lock before terraform destroy: az lock delete --name ...
# ──────────────────────────────────────────────────────────
resource "azurerm_management_lock" "rg_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "lock-nodelete-${var.project_name}-${var.environment}"
  scope      = module.resource_group.resource_id
  lock_level = "CanNotDelete"
  notes      = "AethronOps governance — prevent accidental deletion. Remove before terraform destroy."
  depends_on = [module.log_analytics, module.managed_identity]
}

resource "azurerm_management_lock" "log_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "lock-log-${var.project_name}-${var.environment}"
  scope      = module.log_analytics.resource_id
  lock_level = "CanNotDelete"
  notes      = "AethronOps governance — Log Analytics CanNotDelete lock. Deletion = loss of audit logs (DORA Art.13, NIS2)."
}

# ──────────────────────────────────────────────────────────
# AZURE POLICY — Enterprise security guardrails
# Built-in policies assigned at Resource Group scope.
# Default mode: Audit (detect violations without blocking).
# Set policy_enforcement_mode = true for Deny mode.
# MCSB AM-2 (approved services), NS-2 (secure endpoints)
# ──────────────────────────────────────────────────────────

# Policy: Require tags on resources (AM-2, governance)
resource "azurerm_resource_group_policy_assignment" "require_tags" {
  count = var.enable_resource_locks ? 1 : 0

  name                 = "pol-require-tags-${var.environment}"
  resource_group_id    = module.resource_group.resource_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
  display_name         = "Require environment tag on resources"
  enforce              = var.policy_enforcement_mode

  parameters = jsonencode({
    tagName = { value = "environment" }
  })
}

# Policy: Enforce HTTPS on Storage Accounts (DP-3)
resource "azurerm_resource_group_policy_assignment" "enforce_https_storage" {
  count = var.enable_resource_locks ? 1 : 0

  name                 = "pol-https-storage-${var.environment}"
  resource_group_id    = module.resource_group.resource_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9"
  display_name         = "Secure transfer to storage accounts should be enabled"
  enforce              = var.policy_enforcement_mode
}

# Policy: Enforce TLS 1.2 minimum (DP-3)
resource "azurerm_resource_group_policy_assignment" "enforce_tls" {
  count = var.enable_resource_locks ? 1 : 0

  name                 = "pol-tls12-${var.environment}"
  resource_group_id    = module.resource_group.resource_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/f0e6e85b-9b9f-4a4b-b67b-f730d42f1b0b"
  display_name         = "Latest TLS version should be used"
  enforce              = var.policy_enforcement_mode
}
