# ============================================================
# AethronOps v2 — Terraform Variables
# Tier: basic | Generated: 2026-03-26
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

project_name    = "storage-baseline"
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
  project = "storage-baseline"
}

# ────────────────────────────────────────────────────────────
# MANDATORY ENTERPRISE TAGS — Required for governance (CAF/MCSB AM-1)
# ────────────────────────────────────────────────────────────

cost_center           = "unassigned"    # TODO: Set your cost center code (e.g. "IT-1234")
owner                 = "unassigned"    # TODO: Set owner email or team (e.g. "team@company.com")
data_classification   = "internal"      # public | internal | confidential | restricted
confidentiality_level = "C2"            # C1=public | C2=internal | C3=confidential | C4=restricted
criticality           = "low"                              # low | medium | high | critical
operational_hours     = "business-hours"              # 24x7 | business-hours | extended | on-demand
backup_policy         = "basic"            # none | basic | standard | premium | immutable

# ────────────────────────────────────────────────────────────
# ENTERPRISE OPTIONS — Uncomment and adapt as needed
# ────────────────────────────────────────────────────────────

# custom_tags = {
#   business_unit  = "finance"
#   compliance     = "nis2"
#   backup_policy  = "gold"
# }

# require_private_endpoints = true    # Zero-trust: force private endpoints on all PaaS
# allowed_locations = ["westeurope", "francecentral"]  # Geo-fencing policy
# security_contact_email = "security@company.com"   # Alert notifications
enable_resource_locks = false  # Enable AFTER first deploy — ISO 27001 A.8.3: prevent accidental deletion
policy_enforcement_mode = false  # Audit only — set to true AFTER first deploy for Deny mode

# ────────────────────────────────────────────────────────────
# FINOPS — Cost Optimization
# ────────────────────────────────────────────────────────────

enable_finops = true
monthly_budget_eur = 50
budget_alert_emails = ["finops@company.com"]  # TODO: Change to your team email
finops_webhook_url = ""  # Optional: Teams/Slack webhook for alerts
log_retention_days = 30
enable_storage_lifecycle = true
storage_cool_after_days = 30
storage_archive_after_days = 90
