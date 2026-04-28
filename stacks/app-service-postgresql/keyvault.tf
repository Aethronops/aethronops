# ============================================================
# AETHRONOPS v3 — KEYVAULT
# Pattern  : app-service-postgresql / dev
# Tier     : dev
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
# RGPD : ART-32
# NIS2 : ART-21-2h
# ──────────────────────────────────────────────────────────
module "key_vault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "~> 0.10"

  name                = "${trimsuffix(substr("kv-${local.name_prefix}", 0, 18), "-")}-${random_string.storage_suffix.result}"
  location            = var.location
  resource_group_name = module.resource_group.name

  tenant_id                      = data.azurerm_client_config.current.tenant_id
  sku_name                       = "standard"
  soft_delete_retention_days     = 7
  purge_protection_enabled       = false
  public_network_access_enabled  = true
  legacy_access_policies_enabled = false
  network_acls = var.keyvault_network_hardened ? {
    default_action = "Deny"
    bypass         = "AzureServices"
  } : null
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
      workspace_resource_id = module.log_analytics.resource_id
      log_groups            = ["allLogs"]
    }
  }

  tags             = local.common_tags
  enable_telemetry = false
}
