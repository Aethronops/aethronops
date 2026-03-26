# ============================================================
# AETHRONOPS v2 — AUTOMATION
# Pattern  : governance-subscription / premium
# Tier     : premium
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : AUTOMATION-ACCOUNT
# Module AVM : Azure/avm-res-automation-automationaccount/azurerm
# Version    : ~> 0.2
# CAF : MGMT-1, NAMING-1
# Ref : https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
# MCSB : IM-3, LT-3
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-identity-management
# RGPD : ART-32
# NIS2 : ART-21-2e, ART-21-2f
# ──────────────────────────────────────────────────────────
module "automation_account" {
  source  = "Azure/avm-res-automation-automationaccount/azurerm"
  version = "0.2.0"

  name     = trimsuffix(substr("aa-${local.name_prefix}", 0, 50), "-")
  location = var.location
  resource_group_name = module.resource_group.name

  sku                           = "Basic"
  public_network_access_enabled = false

  tags             = local.common_tags
  enable_telemetry = false
}
