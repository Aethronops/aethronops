# ============================================================
# AETHRONOPS v2 — WIRING
# Pattern  : static-web-app / standard
# Tier     : standard
# ============================================================
# Auto-generated connections between bricks.
# Key Vault secrets, role assignments, diagnostic settings.
# ============================================================

# ──────────────────────────────────────────────────────────
# RBAC: Managed Identity → Key Vault (Secrets User)
# AVM Key Vault defaults to RBAC mode — access policies
# are NOT supported. Uses role assignment instead.
# ──────────────────────────────────────────────────────────
resource "azurerm_role_assignment" "mi_keyvault_secrets" {
  scope                = module.key_vault.resource_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.managed_identity.principal_id
}

# ──────────────────────────────────────────────────────────
# Role assignment: Managed Identity → Storage Account
# Allows passwordless access to blob storage.
# ──────────────────────────────────────────────────────────
resource "azurerm_role_assignment" "mi_storage_blob" {
  scope                = module.storage_account.resource_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.managed_identity.principal_id
}

# ──────────────────────────────────────────────────────────
# VNet Flow Logs (MCSB LT-4: network logging)
# Replaces deprecated NSG Flow Logs (Azure June 2025).
# Captures ALL traffic flows on the VNet — ingress + egress.
# Traffic Analytics enabled for security threat detection.
#
# Ref: https://learn.microsoft.com/azure/network-watcher/vnet-flow-logs-overview
# ──────────────────────────────────────────────────────────

# Network Watcher is auto-provisioned by Azure per region.
# We reference the default one created in the NetworkWatcherRG.
# WARNING: On fresh subscriptions where no VNet has been deployed yet,
# NetworkWatcherRG and NetworkWatcher_<region> may not exist.
# If terraform plan fails on this data source, deploy a VNet first
# or manually create the Network Watcher via:
#   az network watcher configure -g NetworkWatcherRG -l <region> --enabled true
data "azurerm_network_watcher" "main" {
  name                = "NetworkWatcher_${var.location}"
  resource_group_name = "NetworkWatcherRG"
}

resource "azurerm_network_watcher_flow_log" "vnet" {
  name                 = "flowlog-vnet-${local.name_prefix}"
  network_watcher_name = data.azurerm_network_watcher.main.name
  resource_group_name  = data.azurerm_network_watcher.main.resource_group_name

  # VNet Flow Logs: target_resource_id points to VNet (NOT NSG)
  target_resource_id = module.virtual_network.resource_id
  storage_account_id = module.storage_account.resource_id
  enabled            = true

  retention_policy {
    enabled = true
    days    = 90
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = module.log_analytics.resource.workspace_id
    workspace_region      = var.location
    workspace_resource_id = module.log_analytics.resource_id
    interval_in_minutes   = 60
  }

  depends_on = [data.azurerm_network_watcher.main]

  tags = local.common_tags
}

# ──────────────────────────────────────────────────────────
# NAT Gateway: Public IP + Subnet Association
# Azure March 2026: new VNets have no default outbound internet.
# NAT Gateway provides controlled, auditable outbound connectivity.
# MCSB NS-1: network segmentation — outbound via fixed IP
#
# LIMITATIONS (Azure platform):
#   - DDoS Protection: Public IPs associated to NAT Gateway CANNOT
#     have DDoS Protection Standard. Use VNet-level DDoS Plan instead.
#   - Diagnostic settings: NAT Gateway metrics export via diagnostic
#     settings is NOT supported by Azure. Monitor via Azure Monitor
#     metrics (Bytes/Packets/SNAT Connection Count) directly.
#   Ref: https://learn.microsoft.com/azure/nat-gateway/nat-gateway-resource
# ──────────────────────────────────────────────────────────

# Public IP for NAT Gateway — static, zone-redundant (Standard SKU)
resource "azurerm_public_ip" "nat_pip" {
  name                = "pip-ng-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]

  tags = local.common_tags
}

# Associate Public IP to NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "nat_pip" {
  nat_gateway_id       = module.nat_gateway.resource_id
  public_ip_address_id = azurerm_public_ip.nat_pip.id
}

# Associate NAT Gateway to application subnet
resource "azurerm_subnet_nat_gateway_association" "app_subnet" {
  subnet_id      = module.virtual_network.subnets["snet-app"].resource_id
  nat_gateway_id = module.nat_gateway.resource_id

  depends_on = [azurerm_nat_gateway_public_ip_association.nat_pip]
}

# ──────────────────────────────────────────────────────────
# VNet Peering — Hub-Spoke bidirectionnel (MCSB NS-1)
# Conditional: enabled only when hub_vnet_id is set.
#
# NETWORK PROTECTIONS:
#   - Azure management lock CanNotDelete on VNet and RG (governance.tf)
#   - data source validates Hub VNet exists BEFORE creating peering
#   - precondition validates consistency of the 3 hub variables (variables.tf)
#   - depends_on enforces creation order
# ──────────────────────────────────────────────────────────

# Hub VNet lookup — ensures the target exists before peering
data "azurerm_virtual_network" "hub" {
  count = var.hub_vnet_id != "" ? 1 : 0

  name                = var.hub_vnet_name
  resource_group_name = var.hub_resource_group_name
}

# Spoke -> Hub peering
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  count = var.hub_vnet_id != "" ? 1 : 0

  name                      = "peer-${var.project_name}-${var.environment}-to-hub"
  resource_group_name       = module.resource_group.name
  virtual_network_name      = module.virtual_network.name
  remote_virtual_network_id = var.hub_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false

  # CanNotDelete lock on VNet (governance.tf) prevents accidental removal.
  # Peering can be recreated in seconds if needed.

  depends_on = [data.azurerm_virtual_network.hub]
}

# Hub -> Spoke peering (created in Hub RG)
# NOTE: requires Network Contributor rights on the Hub resource group
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  count = var.hub_vnet_id != "" ? 1 : 0

  name                      = "peer-hub-to-${var.project_name}-${var.environment}"
  resource_group_name       = var.hub_resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = module.virtual_network.resource_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false

  # CanNotDelete lock on Hub VNet prevents deletion of the hub VNet
  # (which would break all peerings in the hub-spoke topology).

  depends_on = [azurerm_virtual_network_peering.spoke_to_hub]
}


# ══════════════════════════════════════════════════════════
# DIAGNOSTIC SETTINGS — Centralized logging (MCSB LT-3/LT-5/LT-6)
# All resource logs → Log Analytics Workspace
# NIS2 Art.21(2)(b), DORA Art.13, ISO 27001 A.8.15
# ══════════════════════════════════════════════════════════

resource "azurerm_monitor_diagnostic_setting" "diag_storage_account" {
  name                       = trimsuffix(substr("diag-storage-account-${local.name_prefix}", 0, 90), "-")
  target_resource_id         = module.storage_account.resource_id
  log_analytics_workspace_id = module.log_analytics.resource_id

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "diag_nat_gateway" {
  name                       = trimsuffix(substr("diag-nat-gateway-${local.name_prefix}", 0, 90), "-")
  target_resource_id         = module.nat_gateway.resource_id
  log_analytics_workspace_id = module.log_analytics.resource_id

  enabled_metric {
    category = "AllMetrics"
  }
}


# ══════════════════════════════════════════════════════════
# KEY VAULT SECRET EXPIRY ALERTS — MCSB DP-6/DP-7
# Notify 30 days before secret expiration
# ISO 27001 A.8.24, CIS Azure 8.4
# ══════════════════════════════════════════════════════════

# Event Grid subscription for Key Vault secret near-expiry events
resource "azurerm_eventgrid_system_topic" "kv_events" {
  name                   = trimsuffix(substr("evgt-kv-${local.name_prefix}", 0, 50), "-")
  resource_group_name    = module.resource_group.name
  location               = var.location
  source_arm_resource_id = module.key_vault.resource_id
  topic_type             = "Microsoft.KeyVault.vaults"

  # Azure Event Grid System Topics have a 15-tag limit.
  tags = {
    environment = var.environment
    project     = var.project_name
    managed_by  = "terraform"
    iac_source  = var.iac_source
  }
}

# Event Grid event subscription is NOT created automatically.
# The system topic above captures KV events. To route them:
#   Option 1: Add a Logic App with HTTP trigger
#   Option 2: Use azurerm_eventgrid_system_topic_event_subscription
# The KQL alert below provides secret expiry monitoring without a webhook.

# Metric alert: secrets approaching expiration (MCSB DP-7)
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "secret_expiry_warning" {
  count = var.enable_finops && length(var.budget_alert_emails) > 0 ? 1 : 0

  name                = "alert-secret-expiry-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  location            = var.location
  description         = "Key Vault secrets expiring within ${var.kv_notify_days_before_expiry} days — rotate immediately (MCSB DP-7)"
  severity            = 2  # Warning
  enabled             = true

  scopes                    = [module.log_analytics.resource_id]
  evaluation_frequency      = "PT6H"
  window_duration           = "PT6H"

  criteria {
    query = <<-KQL
      AzureDiagnostics
      | where ResourceProvider == "MICROSOFT.KEYVAULT"
      | where OperationName == "SecretNearExpiry" or OperationName == "SecretExpired"
      | project TimeGenerated, Resource, OperationName, ResultDescription
    KQL

    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0
  }

  action {
    action_groups = [azurerm_monitor_action_group.finops[0].id]
  }

  tags = local.common_tags
}
