# ============================================================
# AETHRONOPS v3 — MONITORING
# Pattern  : container-apps-cosmosdb / dev
# Tier     : dev
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : LOG-ANALYTICS
# Module AVM : Azure/avm-res-operationalinsights-workspace/azurerm
# Version    : ~> 0.4
# Log Analytics is the central hub for all logs and
# metrics from your Azure infrastructure.
# All other bricks send their diagnostics here.
# Without centralized logs, you are blind during incidents:
# you don't know what happened, when, and who did it.
# It is also the foundation for all alerts and dashboards.
# CAF : OPS-1, OPS-2, GOV-3
# Ref : https://learn.microsoft.com/azure/cloud-adoption-framework/manage/monitor
# MCSB : LT-1, LT-3, LT-4, LT-5, LT-6, IR-1
# RGPD : ART-30, ART-32, ART-33
# NIS2 : ART-21-2b, ART-21-2f
# ──────────────────────────────────────────────────────────
module "log_analytics" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "~> 0.4"

  name                = trimsuffix(substr("log-${local.name_prefix}", 0, 63), "-")
  location            = var.location
  resource_group_name = module.resource_group.name

  log_analytics_workspace_sku                        = "PerGB2018"
  log_analytics_workspace_retention_in_days          = 30
  log_analytics_workspace_internet_ingestion_enabled = true
  log_analytics_workspace_internet_query_enabled     = true

  tags             = local.common_tags
  enable_telemetry = false
}
