# ============================================================
# AETHRONOPS v3 — DATABASE
# Pattern  : container-apps-mongodb / dev
# Tier     : dev
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : MONGO-CLUSTER
# Module AVM : Azure/avm-res-documentdb-mongocluster/azurerm
# Version    : ~> 0.1
# Azure DocumentDB (MongoDB vCore): managed MongoDB database with native
# wire protocol compatibility. Predictable vCore-based pricing (not RU).
# Zone-redundant HA, continuous 30-day backup, Entra ID auth (2026 preview),
# built-in vector search for AI applications.
# CAF : DATA-1, DATA-2
# Ref : https://learn.microsoft.com/azure/documentdb/overview
# MCSB : DP-1, DP-3, DP-4, NS-2
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-data-protection
# RGPD : ART-32, ART-25
# NIS2 : ART-21-2c, ART-21-2e
# ──────────────────────────────────────────────────────────
module "mongo_cluster" {
  source  = "Azure/avm-res-documentdb-mongocluster/azurerm"
  version = "~> 0.1"

  name                = "${trimsuffix(substr("mon-${local.name_prefix}", 0, 35), "-")}-${random_string.storage_suffix.result}"
  location            = var.location
  resource_group_name = module.resource_group.name

  compute_tier                 = var.mongodb_compute_tier
  storage_size_gb              = var.mongodb_storage_gb
  server_version               = var.mongodb_version
  ha_mode                      = var.mongodb_ha_mode
  backup_policy_type           = var.mongodb_backup_policy
  administrator_login          = var.mongodb_admin_login
  administrator_login_password = random_password.mongo_admin.result
  public_network_access        = "Enabled"
  firewall_rules = [{
    name     = "AllowAzureServices"
    start_ip = "0.0.0.0"
    end_ip   = "0.0.0.0"
  }]
  diagnostic_settings = {}

  tags             = local.common_tags
  enable_telemetry = false
}
