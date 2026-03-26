# ============================================================
# AETHRONOPS v2 — KEYVAULT
# Pattern  : storage-baseline / premium
# Tier     : premium
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : KEY-VAULT
# Module AVM : Azure/avm-res-keyvault-vault/azurerm
# Version    : ~> 0.10
# Azure Key Vault is the centralized vault for all
# your secrets, encryption keys, and certificates.
# Your apps retrieve their secrets at runtime via
# their Managed Identity -- never stored in code.
# All operations are logged and auditable.
# CAF : SEC-3, SEC-4
# Ref : https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
# MCSB : DP-1, DP-2, DP-3, DP-4, DP-6, DP-7, DP-8
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-data-protection
# RGPD : ART-32
# NIS2 : ART-21-2h
# DORA : ART-9, ART-12
# Ref : https://learn.microsoft.com/compliance/dora/
# ──────────────────────────────────────────────────────────
module "key_vault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.10.2"

  name     = trimsuffix(substr("kv-${local.name_prefix}", 0, 24), "-")
  location = var.location
  resource_group_name = module.resource_group.name

  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "premium"
  soft_delete_retention_days    = var.environment == "dev" ? 7 : 90
  purge_protection_enabled      = contains(["prod", "uat", "staging"], var.environment)
  public_network_access_enabled = false
  legacy_access_policies_enabled = false
  network_acls = {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
  role_assignments = {
    deployer = {
      role_definition_id_or_name = "Key Vault Administrator"
      principal_id               = data.azurerm_client_config.current.object_id
    }
  }
  wait_for_rbac_before_secret_operations = {
    create = "60s"
  }
  wait_for_rbac_before_key_operations = {
    create = "60s"
  }
  # BUG-017: disable AVM internal azapi diag_setting — use azurerm standalone instead

  diagnostic_settings = {
    default = {
      name                  = trimsuffix(substr("diag-key_vault-${local.name_prefix}", 0, 90), "-")
      workspace_resource_id  = module.log_analytics.resource_id
      log_groups             = ["allLogs"]
    }
  }

  tags             = local.common_tags
  enable_telemetry = false
}
