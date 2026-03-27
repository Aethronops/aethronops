# ============================================================
# AETHRONOPS v2 — NATGATEWAY
# Pattern  : static-web-app / premium
# Tier     : premium
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : NAT-GATEWAY
# Module AVM : Azure/avm-res-network-natgateway/azurerm
# Version    : ~> 0.3
# CAF : NET-1, NAMING-1
# Ref : https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
# MCSB : NS-1, NS-2
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-network-security
# NIS2 : ART-21-2a
# ──────────────────────────────────────────────────────────
module "nat_gateway" {
  source  = "Azure/avm-res-network-natgateway/azurerm"
  version = "0.3.2"

  name     = trimsuffix(substr("ng-${local.name_prefix}", 0, 80), "-")
  location = var.location
  parent_id = module.resource_group.resource_id

  idle_timeout_in_minutes = 10
  sku_name                = "Standard"

  tags             = local.common_tags
  enable_telemetry = false
}
