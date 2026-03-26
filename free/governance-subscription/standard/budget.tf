# ============================================================
# AETHRONOPS v2 — BUDGET
# Pattern  : governance-subscription / standard
# Tier     : standard
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : SUBSCRIPTION-BUDGET
# Resource :  (native azurerm)
# CAF : FINOPS-1, GOV-1
# MCSB : AM-3
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-asset-management
# ──────────────────────────────────────────────────────────
resource "azurerm_consumption_budget_subscription" "main" {
  name            = "budget-${local.name_prefix}"
  subscription_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  amount          = var.monthly_budget_eur
  time_grain      = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01'T'00:00:00Z", timestamp())
  }

  notification {
    enabled        = true
    threshold      = 50
    operator       = "GreaterThanOrEqualTo"
    threshold_type = "Actual"
    contact_emails = var.budget_alert_emails
  }
  notification {
    enabled        = true
    threshold      = 75
    operator       = "GreaterThanOrEqualTo"
    threshold_type = "Actual"
    contact_emails = var.budget_alert_emails
  }
  notification {
    enabled        = true
    threshold      = 90
    operator       = "GreaterThanOrEqualTo"
    threshold_type = "Actual"
    contact_emails = var.budget_alert_emails
  }
  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThanOrEqualTo"
    threshold_type = "Actual"
    contact_emails = var.budget_alert_emails
  }

  lifecycle { ignore_changes = [time_period] }
}
