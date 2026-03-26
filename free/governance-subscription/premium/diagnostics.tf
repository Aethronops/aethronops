# ============================================================
# AETHRONOPS v2 — DIAGNOSTICS
# Pattern  : governance-subscription / premium
# Tier     : premium
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : SUBSCRIPTION-DIAGNOSTIC
# Resource :  (native azurerm)
# CAF : MON-1, SEC-1
# MCSB : LT-3, LT-5
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-logging-threat-detection
# RGPD : ART-30, ART-33
# NIS2 : ART-21-2b
# ──────────────────────────────────────────────────────────
resource "azurerm_monitor_diagnostic_setting" "subscription" {
  name                       = trimsuffix(substr("diag-sub-${local.name_prefix}", 0, 90), "-")
  target_resource_id         = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  log_analytics_workspace_id = module.log_analytics.resource_id

  enabled_log {
    category = "Administrative"
  }
  enabled_log {
    category = "Security"
  }
  enabled_log {
    category = "Alert"
  }
}
