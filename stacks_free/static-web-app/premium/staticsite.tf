# ============================================================
# AETHRONOPS v2 — STATICSITE
# Pattern  : static-web-app / premium
# Tier     : premium
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : STATIC-WEB-APP
# Module AVM : Azure/avm-res-web-staticsite/azurerm
# Version    : ~> 0.4
# CAF : APP-1, NAMING-1
# Ref : https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
# MCSB : DP-3, NS-2
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-data-protection
# RGPD : ART-32, ART-25
# NIS2 : ART-21-2c, ART-21-2e
# ──────────────────────────────────────────────────────────
module "static_web_app" {
  source  = "Azure/avm-res-web-staticsite/azurerm"
  version = "0.6.2"

  name     = trimsuffix(substr("swa-${local.name_prefix}", 0, 40), "-")
  # BUG-026: Static Web Apps unavailable in francecentral — forced to westeurope
  location = "westeurope"
  resource_group_name = module.resource_group.name

  sku_tier = "Standard"
  sku_size = "Free"

  tags             = local.common_tags
  enable_telemetry = false
}
