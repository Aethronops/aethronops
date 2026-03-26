# ============================================================
# AETHRONOPS v2 — BACKUP
# Pattern  : platform-management / premium
# Tier     : premium
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : BACKUP-VAULT
# Module AVM : Azure/avm-res-recoveryservices-vault/azurerm
# Version    : 0.3.2
# The Recovery Services Vault (Azure Backup) protects your data
# against accidental deletions, ransomware, and outages.
# It automatically backs up your Storage Accounts,
# VMs, and databases according to a configurable policy.
# Built-in soft delete provides an additional retention period
# even if an attacker deletes the backups.
# CAF : OPS-3, DATA-3
# Ref : https://learn.microsoft.com/azure/cloud-adoption-framework/manage/azure-best-practices/storage-backup
# MCSB : BR-1, BR-2, BR-3
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-backup-recovery
# RGPD : ART-32
# NIS2 : ART-21-2c, ART-21-2e
# DORA : ART-11, ART-12
# Ref : https://learn.microsoft.com/compliance/dora/
# ──────────────────────────────────────────────────────────
module "backup_vault" {
  source  = "Azure/avm-res-recoveryservices-vault/azurerm"
  version = "0.3.2"

  name     = trimsuffix(substr("bvault-${local.name_prefix}", 0, 50), "-")
  location = var.location
  resource_group_name = module.resource_group.name

  sku                           = "Standard"
  soft_delete_enabled           = true
  cross_region_restore_enabled  = false
  public_network_access_enabled = false
  immutability                  = "Locked"

  diagnostic_settings = {
    default = {
      name                  = trimsuffix(substr("diag-backup_vault-${local.name_prefix}", 0, 90), "-")
      workspace_resource_id  = module.log_analytics.resource_id
      log_groups             = ["allLogs"]
    }
  }

  tags             = local.common_tags
  enable_telemetry = false
}
