# ============================================================
# AETHRONOPS v3 — COSMOSDB
# Pattern  : app-service-cosmosdb / dev
# Tier     : dev
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : COSMOSDB-BASELINE
# Module AVM : Azure/avm-res-documentdb-databaseaccount/azurerm
# Version    : ~> 0.10
# Azure Cosmos DB: globally distributed NoSQL database, < 10ms latency,
# multi-model (SQL, MongoDB, Cassandra, Gremlin, Table),
# 99.999% SLA multi-region, automatic scaling.
# CAF : DATA-1, DATA-2
# Ref : https://learn.microsoft.com/azure/cosmos-db/introduction
# MCSB : DP-1, DP-3, NS-2
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-data-protection
# RGPD : ART-32, ART-25
# NIS2 : ART-21-2c, ART-21-2e
# ──────────────────────────────────────────────────────────
module "cosmosdb_baseline" {
  source  = "Azure/avm-res-documentdb-databaseaccount/azurerm"
  version = "~> 0.10"

  name                = "${trimsuffix(substr("cosmos-${local.name_prefix}", 0, 39), "-")}-${random_string.storage_suffix.result}"
  location            = var.location
  resource_group_name = module.resource_group.name

  consistency_policy = {
    consistency_level = "Session"
  }
  capabilities = [{ name = "EnableServerless" }]
  geo_locations = [{
    location          = var.location
    failover_priority = 0
    zone_redundant    = false
  }]
  public_network_access_enabled = true
  backup = {
    type = "Continuous"
    tier = "Continuous7Days"
  }
  sql_databases = {
    "primary" = { name = "appdb" }
  }
  managed_identities = {
    user_assigned_resource_ids = [module.managed_identity.resource_id]
  }
  # BUG-017: disable AVM internal azapi diag_setting — use azurerm standalone instead

  diagnostic_settings = {
    default = {
      name                  = trimsuffix(substr("diag-cosmosdb_baseline-${local.name_prefix}", 0, 90), "-")
      workspace_resource_id = module.log_analytics.resource_id
      log_groups            = ["allLogs"]
      metric_categories     = ["Requests"]
    }
  }

  # BUG-064/065/069: wait for dependencies to propagate
  depends_on = [module.managed_identity]

  tags             = local.common_tags
  enable_telemetry = false
}
