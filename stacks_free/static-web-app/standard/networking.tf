# ============================================================
# AETHRONOPS v2 — NETWORKING
# Pattern  : static-web-app / standard
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
    "snet-app" = {
      name             = "snet-app"
      address_prefix   = cidrsubnet(var.vnet_address_space, 8, 1)
      delegations = [{
        name = "delegation"
        service_delegation = {
          name = "Microsoft.Web/serverFarms"
        }
      }]
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

# ──────────────────────────────────────────────────────────
# BRICK : NETWORK-SECURITY-GROUP
# Module AVM : Azure/avm-res-network-networksecuritygroup/azurerm
# Version    : 0.5.1
# The NSG is a subnet-level firewall. It filters inbound
# and outbound traffic for each subnet based on precise rules.
# AethronOps applies a default Deny-All inbound rule
# and only explicitly allows the required ports.
# CAF : NET-3
# Ref : https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/perimeter-networks
# MCSB : NS-1
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-network-security#ns-1-establish-network-segmentation-boundaries
# NIS2 : ART-21-2a
# ──────────────────────────────────────────────────────────
module "network_security_group" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.5.1"

  name     = trimsuffix(substr("nsg-${local.name_prefix}", 0, 80), "-")
  location = var.location
  resource_group_name = module.resource_group.name

  security_rules = {
    "AllowHTTPS" = {
      name                       = "AllowHTTPS"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
    "DenyAllInbound" = {
      name                       = "DenyAllInbound"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
  # BUG-017: disable AVM internal azapi diag_setting — use azurerm standalone instead
  diagnostic_settings = {}

  tags             = local.common_tags
  enable_telemetry = false
}
