# ============================================================
# AETHRONOPS v3 — RESOURCE GROUP
# Pattern  : app-service-sql / dev
# Tier     : dev
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : RESOURCE-GROUP
# Module AVM : Azure/avm-res-resources-resourcegroup/azurerm
# Version    : ~> 0.2
# The Resource Group is the logical container for all your
# Azure resources. It lets you organize, manage, tag, and
# bill them together.
# AethronOps creates one RG per functional domain
# (network, security, identity...) for clear governance.
# CAF : RG-1, RG-2, GOV-1
# Ref : https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
# ──────────────────────────────────────────────────────────
module "resource_group" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "~> 0.2"

  name     = local.rg_name
  location = var.location

  tags             = local.common_tags
  enable_telemetry = false
}
