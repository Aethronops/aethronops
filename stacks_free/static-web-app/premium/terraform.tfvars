# ============================================================
# AethronOps v2 — Terraform Variables
# Tier: premium | Generated: 2026-03-26
# Adapt values to your needs. See README.md for details.
# ============================================================
#
# TODO: Adapt these values to your environment
#   1. Change project_name to your project identifier
#   2. Optionally adjust location and tags
#   3. Uncomment enterprise options below as needed
#   Note: subscription_id is auto-detected from ARM_SUBSCRIPTION_ID env var
#
# Run: terraform plan
# ============================================================

project_name    = "static-web-app"
environment     = "dev"
location        = "westeurope"
region_short    = "weu"

# ────────────────────────────────────────────────────────────
# ENTERPRISE NAMING — Makes your resources unique
# ────────────────────────────────────────────────────────────

org_code        = ""            # Your organization code (e.g. "acme", "bnpf")
business_unit   = ""            # Department code (e.g. "fin", "hr", "it")
instance_number = ""            # Instance number (e.g. "001") — for multiple deployments

tags = {
  owner = "aethronops"
  project = "static-web-app"
}

# ────────────────────────────────────────────────────────────
# MANDATORY ENTERPRISE TAGS — Required for governance (CAF/MCSB AM-1)
# ────────────────────────────────────────────────────────────

cost_center           = "unassigned"    # TODO: Set your cost center code (e.g. "IT-1234")
owner                 = "unassigned"    # TODO: Set owner email or team (e.g. "team@company.com")
data_classification   = "internal"      # public | internal | confidential | restricted
confidentiality_level = "C2"            # C1=public | C2=internal | C3=confidential | C4=restricted
criticality           = "critical"                              # low | medium | high | critical
operational_hours     = "24x7"              # 24x7 | business-hours | extended | on-demand
backup_policy         = "premium"            # none | basic | standard | premium | immutable

# ────────────────────────────────────────────────────────────
# ENTERPRISE OPTIONS — Uncomment and adapt as needed
# ────────────────────────────────────────────────────────────

# custom_tags = {
#   business_unit  = "finance"
#   compliance     = "nis2"
#   backup_policy  = "gold"
# }

require_private_endpoints = true    # Zero-trust: force private endpoints on all PaaS
# allowed_locations = ["westeurope", "francecentral"]  # Geo-fencing policy
# security_contact_email = "security@company.com"   # Alert notifications
enable_resource_locks = false  # Enable AFTER first deploy — ISO 27001 A.8.3: prevent accidental deletion
policy_enforcement_mode = false  # Audit only — set to true AFTER first deploy for Deny mode

# ────────────────────────────────────────────────────────────
# NETWORKING — VNet address space
# Hub = 10.0.0.0/16, dev = 10.1.0.0/16, uat = 10.2.0.0/16, prod = 10.3.0.0/16
# ────────────────────────────────────────────────────────────

vnet_address_space = "10.1.0.0/16"

# ────────────────────────────────────────────────────────────
# HUB-SPOKE PEERING — Connect to hub VNet
#
# ⚠ WARNING — MODIFIES EXISTING NETWORK:
#   - Peering creates a resource in the Hub RG (hub_to_spoke)
#   - SP/OIDC must have 'Network Contributor' on the Hub RG
#   - Spoke CIDR must NOT overlap with hub or other spokes
#   - terraform destroy will remove the peering (prevent_destroy enabled)
#   - Test in dev BEFORE applying to prod
#
# Leave hub_vnet_id empty to disable peering.
# All 3 variables must be ALL set or ALL empty.
# ────────────────────────────────────────────────────────────

hub_vnet_id              = ""   # /subscriptions/.../virtualNetworks/vnet-hub-prod-frc
hub_vnet_name            = ""   # vnet-hub-prod-frc
hub_resource_group_name  = ""   # rg-hub-prod-frc
# hub_firewall_private_ip not used in this tier (no route-table + VM or not standard/premium)

# ────────────────────────────────────────────────────────────
# FINOPS — Cost Optimization
# ────────────────────────────────────────────────────────────

enable_finops = true
monthly_budget_eur = 1000
budget_alert_emails = ["finops@company.com"]  # TODO: Change to your team email
finops_webhook_url = ""  # Optional: Teams/Slack webhook for alerts
log_retention_days = 365
enable_storage_lifecycle = true
storage_cool_after_days = 90
storage_archive_after_days = 365
