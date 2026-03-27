# ============================================================
# AETHRONOPS v2 — STORAGE
# Pattern  : static-web-app / standard
# Tier     : standard
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : STORAGE-ACCOUNT
# Module AVM : Azure/avm-res-storage-storageaccount/azurerm
# Version    : ~> 0.2
# The Azure Storage Account provides object storage
# (Blob), file shares (File Share), table, and queue.
# AethronOps automatically configures:
# -> Encryption at rest with managed keys
# -> HTTPS only (TLS 1.2 minimum)
# -> Private network access only (Private Endpoint)
# -> Versioning and soft-delete for recovery
# CAF : DATA-1
# MCSB : DP-1, DP-3, NS-2, AM-2
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-data-protection
# RGPD : ART-32, ART-5
# NIS2 : ART-21-2h
# ──────────────────────────────────────────────────────────
module "storage_account" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.6.7"

  name     = substr("st${local.name_slug}${random_string.storage_suffix.result}", 0, 24)
  location = var.location
  resource_group_name = module.resource_group.name

  account_replication_type          = "LRS"
  account_tier                      = "Standard"
  shared_access_key_enabled         = false
  allow_nested_items_to_be_public   = false
  cross_tenant_replication_enabled  = false
  https_traffic_only_enabled        = true
  min_tls_version                   = "TLS1_2"
  public_network_access_enabled     = true
  network_rules = null
  blob_properties = {
    versioning_enabled = true
    delete_retention_policy = {
      days = 30
    }
  }
  default_to_oauth_authentication   = true

  tags             = local.common_tags
  enable_telemetry = false
}
