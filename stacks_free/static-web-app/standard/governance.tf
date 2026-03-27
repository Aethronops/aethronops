# ============================================================
# AETHRONOPS v2 — ENTERPRISE GOVERNANCE
# Pattern  : static-web-app / standard
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
  depends_on = [module.application_insights, module.key_vault, module.log_analytics, module.managed_identity, module.nat_gateway, module.network_security_group, module.static_web_app, module.storage_account, module.virtual_network]
}

resource "azurerm_management_lock" "kv_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "lock-kv-${var.project_name}-${var.environment}"
  scope      = module.key_vault.resource_id
  lock_level = "CanNotDelete"
  notes      = "AethronOps governance — Key Vault CanNotDelete lock."
}

resource "azurerm_management_lock" "vnet_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "lock-vnet-${var.project_name}-${var.environment}"
  scope      = module.virtual_network.resource_id
  lock_level = "CanNotDelete"
  notes      = "AethronOps governance — VNet CanNotDelete lock. Deletion = total connectivity loss (peerings, subnets, PE)."
}

resource "azurerm_management_lock" "storage_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "lock-storage-${var.project_name}-${var.environment}"
  scope      = module.storage_account.resource_id
  lock_level = "CanNotDelete"
  notes      = "AethronOps governance — Storage Account CanNotDelete lock. Deletion = data loss (blobs, audit logs, WORM)."
}

resource "azurerm_management_lock" "log_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "lock-log-${var.project_name}-${var.environment}"
  scope      = module.log_analytics.resource_id
  lock_level = "CanNotDelete"
  notes      = "AethronOps governance — Log Analytics CanNotDelete lock. Deletion = loss of audit logs (DORA Art.13, NIS2)."
}

resource "azurerm_management_lock" "nat_gw_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "lock-ng-${var.project_name}-${var.environment}"
  scope      = module.nat_gateway.resource_id
  lock_level = "CanNotDelete"
  notes      = "AethronOps governance — NAT Gateway CanNotDelete lock. Deletion = loss of outbound connectivity for all associated subnets (MCSB NS-1)."
}

# ──────────────────────────────────────────────────────────
# IMMUTABLE AUDIT STORAGE — Write-Once-Read-Many (WORM)
# 90-day legal retention for audit trail integrity
# SOC 2 CC7.2, DORA Art.12/13, ISO 27001 A.8.10
# ──────────────────────────────────────────────────────────
resource "azurerm_storage_container" "audit_logs" {
  name                  = "audit-logs"
  storage_account_id    = module.storage_account.resource_id
  container_access_type = "private"
}

# Time-based immutability — DORA Art.12, SOC 2 CC7.2
# Blobs cannot be modified or deleted during retention period.
# WARNING: Once locked, this policy CANNOT be shortened or removed.
resource "azurerm_storage_container_immutability_policy" "audit_worm" {
  storage_container_resource_manager_id = azurerm_storage_container.audit_logs.id
  immutability_period_in_days           = 90
}

# Lifecycle cost optimization for audit blobs is handled by the
# unified storage_management_policy in finops.tf (Azure allows only
# ONE management policy per storage account).

# ──────────────────────────────────────────────────────────
# KEY VAULT ROTATION REMINDER — Automated expiry notification
# Secrets expire after 360 days, notify 90 days before
# ISO 27001 A.8.24 (secret lifecycle), CIS Azure 8.4
# ──────────────────────────────────────────────────────────
variable "kv_secret_expiry_days" {
  description = "Days until Key Vault secrets expire (rotation cycle)"
  type        = number
  default     = 360
}

variable "kv_notify_days_before_expiry" {
  description = "Days before expiry to send notification"
  type        = number
  default     = 90
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
