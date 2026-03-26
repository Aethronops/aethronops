# ============================================================
# AETHRONOPS v2 — IDENTITY
# Pattern  : platform-management / basic
# Tier     : basic
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : MANAGED-IDENTITY
# Module AVM : Azure/avm-res-managedidentity-userassignedidentity/azurerm
# Version    : ~> 0.3
# Managed Identity is an Azure AD identity automatically
# managed by Azure for your resources.
# Your apps and services can authenticate to other
# Azure services (Key Vault, Storage, DB) WITHOUT storing
# any password or API key in code.
# CAF : ID-1, ID-2
# Ref : https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/identity-access-management
# MCSB : IM-1, IM-3
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-identity-management
# RGPD : ART-25, ART-32
# NIS2 : ART-21-2i
# ──────────────────────────────────────────────────────────
module "managed_identity" {
  source  = "Azure/avm-res-managedidentity-userassignedidentity/azurerm"
  version = "0.4.0"

  name     = trimsuffix(substr("id-${local.name_prefix}", 0, 128), "-")
  location = var.location
  resource_group_name = module.resource_group.name

  tags             = local.common_tags
  enable_telemetry = false
}
