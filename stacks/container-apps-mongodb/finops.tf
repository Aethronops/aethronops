# ============================================================
# AETHRONOPS v3 — FINOPS COST OPTIMIZATION
# Pattern  : container-apps-mongodb / dev
# Tier     : dev
# ============================================================
#
# This file contains automated cost-saving resources:
#   - Action Group (centralized notifications)
#   - Budget alerts (50%, 80%, 100%, 120%)
#   - Cost anomaly detection alerts
#   - VM Start/Stop Automation (tag-based JSON schedules)
#   - PaaS Start/Stop Automation (App Service, AKS, DB Flexible)
#   - Storage lifecycle management (Hot → Cool → Archive)
#   - Recommendations in comments (RI, Savings Plans, etc.)
#
# Set enable_finops = false to disable all FinOps resources.
# ============================================================

# ──────────────────────────────────────────────────────────
# ACTION GROUP — Centralized notification channel
# Used by budget alerts, anomaly detection, and monitoring
# Supports: email, SMS, webhook (Teams/Slack), Azure Function
# ──────────────────────────────────────────────────────────

resource "azurerm_monitor_action_group" "finops" {
  count = var.enable_finops && length(var.budget_alert_emails) > 0 ? 1 : 0

  name                = trimsuffix(substr("ag-finops-${var.project_name}-${var.environment}", 0, 80), "-")
  resource_group_name = module.resource_group.name
  short_name          = "finops"

  dynamic "email_receiver" {
    for_each = var.budget_alert_emails
    content {
      name          = "finops-${email_receiver.key}"
      email_address = email_receiver.value
    }
  }

  dynamic "webhook_receiver" {
    for_each = var.finops_webhook_url != "" ? [1] : []
    content {
      name        = "teams-slack"
      service_uri = var.finops_webhook_url
    }
  }

  tags = local.common_tags
}

# ──────────────────────────────────────────────────────────
# BUDGET ALERT — Monthly spending watchdog
# Sends email at 50%, 80%, 100%, 120% of budget
# ──────────────────────────────────────────────────────────

resource "azurerm_consumption_budget_resource_group" "finops" {
  count = var.enable_finops && length(var.budget_alert_emails) > 0 ? 1 : 0

  name              = trimsuffix(substr("budget-${var.project_name}-${var.environment}", 0, 63), "-")
  resource_group_id = module.resource_group.resource_id
  amount            = var.monthly_budget_eur
  time_grain        = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01'T'00:00:00Z", timestamp())
  }

  # 50% — Early warning
  notification {
    operator       = "GreaterThanOrEqualTo"
    threshold      = 50
    threshold_type = "Actual"
    contact_groups = [azurerm_monitor_action_group.finops[0].id]
  }

  # 80% — Action needed
  notification {
    operator       = "GreaterThanOrEqualTo"
    threshold      = 80
    threshold_type = "Actual"
    contact_groups = [azurerm_monitor_action_group.finops[0].id]
  }

  # 100% — Budget exceeded
  notification {
    operator       = "GreaterThanOrEqualTo"
    threshold      = 100
    threshold_type = "Actual"
    contact_groups = [azurerm_monitor_action_group.finops[0].id]
  }

  # 120% — Forecasted overspend
  notification {
    operator       = "GreaterThan"
    threshold      = 120
    threshold_type = "Forecasted"
    contact_groups = [azurerm_monitor_action_group.finops[0].id]
  }

  lifecycle {
    ignore_changes = [time_period]
  }
}

# ──────────────────────────────────────────────────────────
# COST ANOMALY ALERT — Detect unexpected spending spikes
# Azure monitors daily costs and alerts on anomalies
# NOTE: Azure subscriptions are limited to 5 cost anomaly alerts.
# This alert is subscription-scoped, so it is only created once
# in 01-platform (or dev standalone) — NOT in each 02-{stack}.
# ──────────────────────────────────────────────────────────

resource "azurerm_cost_anomaly_alert" "finops" {
  count = var.enable_finops && var.enable_cost_anomaly_alert && length(var.budget_alert_emails) > 0 ? 1 : 0

  name            = trimsuffix(substr("anomaly-${var.project_name}-${var.environment}", 0, 25), "-")
  display_name    = trimsuffix(substr("anomaly-${var.project_name}", 0, 25), "-")
  email_subject   = "Cost anomaly detected — ${var.project_name} (${var.environment})"
  email_addresses = var.budget_alert_emails
  message         = "Azure has detected an unusual spending pattern. Please review Cost Analysis in the Azure Portal."
}

# ============================================================
# FINOPS RECOMMENDATIONS
# ============================================================
#
# 1. RESERVED INSTANCES (RI)
#    For production workloads running 24/7, consider:
#    - 1-year RI: ~30% savings vs pay-as-you-go
#    - 3-year RI: ~50% savings vs pay-as-you-go
#    Apply via Azure Portal > Cost Management > Reservations
#
# 2. SAVINGS PLANS
#    Azure Savings Plans for Compute: commit to $/hr spend
#    - 1-year: ~15% savings
#    - 3-year: ~30% savings
#    More flexible than RI (covers VMs, App Service, Functions)
#
# 3. AZURE HYBRID BENEFIT
#    If you have Windows Server or SQL Server licenses:
#    - Save up to 85% on Windows VMs
#    - Save up to 55% on SQL Database
#    Set in the module: license_type = "BasePrice"
#
# 4. DEV/TEST PRICING
#    Use Azure Dev/Test subscription for non-prod:
#    - No Windows license charges on VMs
#    - Reduced rates on PaaS services
#    - No SLA (suitable for dev/uat only)
#
# 5. RIGHT-SIZING
#    Use Azure Advisor recommendations monthly:
#    az advisor recommendation list --category Cost
#    Typical savings: 20-40% by downsizing oversized resources
#
# 6. SPOT INSTANCES (non-critical workloads)
#    For batch processing, CI/CD, dev environments:
#    - Up to 90% savings vs pay-as-you-go
#    - Can be evicted with 30s notice
#    Set: priority = "Spot", eviction_policy = "Deallocate"
#
# 7. AUTO-SCALE SCHEDULES (already implemented above)
#    VM and PaaS scheduling is automated via Automation Account runbooks.
#    Tag resources with Schedule JSON to control start/stop times.
#    For additional manual scaling beyond tag-based automation:
#    - Cosmos DB: set autoscale max RU/s lower in dev/uat
#    - SQL Database: use serverless tier for auto-pause (built-in)
#    Typical savings: 40-100% on compute costs
#
# 8. AZURE COST MANAGEMENT
#    Enable in Azure Portal > Cost Management:
#    - Set up daily/weekly cost reports
#    - Configure anomaly detection alerts
#    - Use resource tags for cost allocation
#    - Review Cost Analysis by resource group monthly
#
# ============================================================
