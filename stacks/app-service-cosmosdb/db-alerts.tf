# ============================================================
# AETHRONOPS v3 — DB ALERTS
# ============================================================
# Azure Recommended Alerts 2026 — OR Defender for Cloud covers
# anomaly detection with ML. These alerts are the "infrastructure"
# layer (CPU/storage/connections), Defender is the "attack" layer.
# ============================================================

# Action Group — where alerts are sent
resource "azurerm_monitor_action_group" "db_alerts" {
  count               = var.enable_recommended_db_alerts && length(var.budget_alert_emails) > 0 ? 1 : 0
  name                = "ag-db-alerts-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  short_name          = "dbalerts"

  dynamic "email_receiver" {
    for_each = toset(var.budget_alert_emails)
    content {
      name          = "email-${replace(replace(email_receiver.value, "@", "-at-"), ".", "-")}"
      email_address = email_receiver.value
    }
  }

  tags = local.common_tags
}

locals {
  db_alerts_enabled         = var.enable_recommended_db_alerts && length(var.budget_alert_emails) > 0 ? 1 : 0
  db_alerts_action_group_id = local.db_alerts_enabled == 1 ? azurerm_monitor_action_group.db_alerts[0].id : null
}

# Normalized RU consumption > 80%
resource "azurerm_monitor_metric_alert" "cosmos_normalizedruconsumption" {
  count               = local.db_alerts_enabled
  name                = "alert-cosmos-normalizedruconsumpt-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  scopes              = [module.cosmosdb_baseline.resource_id]
  description         = "Normalized RU consumption > 80%"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.DocumentDB/databaseAccounts"
    metric_name      = "NormalizedRUConsumption"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = local.db_alerts_action_group_id
  }

  tags = local.common_tags
}

# Total RU/s > 1M (traffic spike)
resource "azurerm_monitor_metric_alert" "cosmos_totalrequestunits" {
  count               = local.db_alerts_enabled
  name                = "alert-cosmos-totalrequestunits-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  scopes              = [module.cosmosdb_baseline.resource_id]
  description         = "Total RU/s > 1M (traffic spike)"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.DocumentDB/databaseAccounts"
    metric_name      = "TotalRequestUnits"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 1000000
  }

  action {
    action_group_id = local.db_alerts_action_group_id
  }

  tags = local.common_tags
}

