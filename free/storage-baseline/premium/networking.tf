# ============================================================
# AETHRONOPS v2 — NETWORKING
# Pattern  : storage-baseline / premium
# Tier     : premium
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

# ──────────────────────────────────────────────────────────
# BRICK : PRIVATE-ENDPOINT-KV
# Module AVM : Azure/avm-res-network-privateendpoint/azurerm
# Version    : 0.2.0
# The Private Endpoint creates a private network interface in your
# VNet that points to an Azure service (Storage, Key Vault, etc.).
# Traffic between your network and the service NEVER transits
# through the internet -- it stays on the Azure backbone.
# Result: your storage data is only accessible from
# your private network, even though it's in the cloud.
# CAF : NET-4, DATA-2
# Ref : https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale
# MCSB : NS-2, DP-3
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-network-security#ns-2-secure-cloud-native-services-with-network-controls
# RGPD : ART-32, ART-25
# NIS2 : ART-21-2a, ART-21-2h
# ──────────────────────────────────────────────────────────
module "private_endpoint_kv" {
  source  = "Azure/avm-res-network-privateendpoint/azurerm"
  version = "0.2.0"

  name     = trimsuffix(substr("pe-kv-${local.name_prefix}", 0, 64), "-")
  location = var.location
  resource_group_name = module.resource_group.name

  network_interface_name         = "nic-pe-${var.project_name}-kv-${var.environment}-${var.region_short}"
  subnet_resource_id             = module.virtual_network.subnets["snet-pe"].resource_id
  private_connection_resource_id = module.key_vault.resource_id
  subresource_names              = ["vault"]
  private_dns_zone_group_name    = local.private_dns_zone_kv_id != "" ? "default" : null
  private_dns_zone_resource_ids  = local.private_dns_zone_kv_id != "" ? [local.private_dns_zone_kv_id] : []

  tags             = local.common_tags
  enable_telemetry = false
}

# ──────────────────────────────────────────────────────────
# BRICK : PRIVATE-ENDPOINT-STORAGE
# Module AVM : Azure/avm-res-network-privateendpoint/azurerm
# Version    : 0.2.0
# The Private Endpoint creates a private network interface in your
# VNet that points to an Azure service (Storage, Key Vault, etc.).
# Traffic between your network and the service NEVER transits
# through the internet -- it stays on the Azure backbone.
# Result: your storage data is only accessible from
# your private network, even though it's in the cloud.
# CAF : NET-4, DATA-2
# Ref : https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale
# MCSB : NS-2, DP-3
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-network-security#ns-2-secure-cloud-native-services-with-network-controls
# RGPD : ART-32, ART-25
# NIS2 : ART-21-2a, ART-21-2h
# ──────────────────────────────────────────────────────────
module "private_endpoint_storage" {
  source  = "Azure/avm-res-network-privateendpoint/azurerm"
  version = "0.2.0"

  name     = trimsuffix(substr("pe-storage-${local.name_prefix}", 0, 64), "-")
  location = var.location
  resource_group_name = module.resource_group.name

  network_interface_name         = "nic-pe-${var.project_name}-storage-${var.environment}-${var.region_short}"
  subnet_resource_id             = module.virtual_network.subnets["snet-pe"].resource_id
  private_connection_resource_id = module.storage_account.resource_id
  subresource_names              = ["blob"]
  private_dns_zone_group_name    = local.private_dns_zone_storage_id != "" ? "default" : null
  private_dns_zone_resource_ids  = local.private_dns_zone_storage_id != "" ? [local.private_dns_zone_storage_id] : []

  tags             = local.common_tags
  enable_telemetry = false
}
