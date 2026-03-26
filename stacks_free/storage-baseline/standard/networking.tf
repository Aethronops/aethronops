# ============================================================
# AETHRONOPS v2 — NETWORKING
# Pattern  : storage-baseline / standard
# Tier     : standard
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : VIRTUAL-NETWORK
# Module AVM : Azure/avm-res-network-virtualnetwork/azurerm
# Version    : 0.17.1
# The Virtual Network is your private network in Azure.
# All your resources communicate within this network,
# isolated from the internet and other Azure tenants.
# The Hub-Spoke topology centralizes security in the Hub
# and isolates workloads in dedicated Spokes.
# CAF : NET-1, NET-2, LZ-1
# Ref : https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology
# MCSB : NS-1, NS-2
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-network-security
# NIS2 : ART-21-2a
# ──────────────────────────────────────────────────────────
module "virtual_network" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.17.1"

  name     = trimsuffix(substr("vnet-${local.name_prefix}", 0, 64), "-")
  location = var.location
  parent_id = module.resource_group.resource_id

  address_space = [var.vnet_address_space]
  subnets = {
    "snet-data" = {
      name             = "snet-data"
      address_prefix   = cidrsubnet(var.vnet_address_space, 8, 1)
    }
    "snet-pe" = {
      name             = "snet-pe"
      address_prefix   = cidrsubnet(var.vnet_address_space, 8, 2)
    }
  }
  diagnostic_settings = {}

  tags             = local.common_tags
  enable_telemetry = false
}
