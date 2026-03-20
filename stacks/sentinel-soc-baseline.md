# Sentinel SOC Baseline

Production-ready Security Operations Center built on Microsoft Sentinel. Pre-configured analytics rules, automation playbooks, MITRE ATT&CK coverage, and data connectors — deploy a functional SOC, not an empty workspace.

**Compliance:** CAF · WAF · MCSB · RGPD · NIS2 · DORA

## Azure Components

- Resource Group
- Log Analytics Workspace (Sentinel foundation)
- Microsoft Sentinel (onboarding + configuration)
- Managed Identity (User-Assigned)
- Key Vault (playbook secrets storage)
- Data Connectors (Entra ID, Azure Activity, Defender for Cloud, Office 365, Threat Intelligence)
- Analytics Rules (Scheduled, NRT, Fusion, MS Security Incident)
- Automation Rules (automated Tier 1 triage)
- Playbooks (Logic App Workflows — notification + enrichment)
- Watchlists (VIP users, critical assets, allowlisted IPs)
- Workbooks (SOC Overview, Incident Dashboard, MITRE Coverage)
- Virtual Network + Subnets
- Network Security Group (NSG)
- Private Endpoint (Key Vault, Log Analytics)
- Private DNS Zone
- Storage Account (long-term log archival)
- Backup Vault

## Available Tiers

- **Basic** (~8 resources) — Log Analytics + Sentinel + basic Data Connectors (Entra ID, Azure Activity) + 5 essential analytics rules (brute force, impossible travel, suspicious admin) + 1 SOC overview workbook. Public access. Ideal for SOC proof-of-concept and small organizations.
- **Standard** (~15 resources) — Adds advanced Data Connectors (Defender for Cloud, Office 365, Threat Intelligence) + 15 analytics rules covering 6 MITRE tactics + Tier 1 automation rules + 2 playbooks (Teams notification + IP enrichment) + Watchlists + VNet isolation + Private Endpoints. For mid-size companies with an internal SOC.
- **Premium** (~22 resources) — Full analytics rules suite (25+ rules, 10+ MITRE tactics) + Tier 1 and Tier 2 automation rules + 4 playbooks (Teams + email + enrichment + auto-block) + advanced Workbooks (MITRE heatmap, incident trends, UEBA insights) + long-term archival (Storage Account + lifecycle policies) + Backup Vault + zone redundancy. For large enterprises and NIS2/DORA compliance requirements.

## What You Get

A complete Terraform project (ZIP) with:

- Multi-file structure (networking.tf, identity.tf, monitoring.tf, sentinel.tf, etc.)
- Azure Verified Modules (AVM) — Microsoft's official Terraform modules
- Pre-configured `terraform.tfvars` for your chosen tier
- MITRE ATT&CK coverage from day one — not an empty Sentinel workspace
- Analytics rules with production-tested KQL queries
- Automated Tier 1 triage — reduces SOC analyst workload immediately
- Ready-to-use playbooks (just configure your Teams/Slack webhook)
- Compliance report (COMPLIANCE.md) with NIS2 Art. 21(2)(b)(f) and DORA Art. 10/13/17 mappings
- Checkov security scanning configuration
- README with SOC onboarding guide (data connectors → analytics → automation → workbooks)

## Prerequisites

Before deploying, ensure your environment meets these requirements:

### Azure Subscription
- Resource providers `Microsoft.OperationalInsights` and `Microsoft.SecurityInsights` registered
- Service Principal or Managed Identity with:
  - `Microsoft Sentinel Contributor`
  - `Log Analytics Contributor`
  - `Logic App Contributor` (if playbooks enabled)

### Licenses (depends on data connectors)
| Data Connector | Required License |
|----------------|-----------------|
| Entra ID sign-in logs | Entra ID P1 or P2 |
| Office 365 logs | Microsoft 365 E3/E5 |
| Defender for Cloud | Defender plan enabled on subscription |
| Azure Activity | None (free) |
| Threat Intelligence | None (free — TAXII feeds) |

**No license = disable the connector in `terraform.tfvars`.** The stack won't fail — connectors are controlled by `enable_connector_*` variables.

## Deployment Guide

### Step 1 — Configure variables

```hcl
# terraform.tfvars — key variables
project          = "soc"
environment      = "prd"
location         = "westeurope"

# Data connectors — enable/disable based on your licenses
enable_connector_entra_id       = true
enable_connector_azure_activity = true
enable_connector_defender       = false   # requires Defender license
enable_connector_office365      = false   # requires M365 E3/E5
enable_connector_threat_intel   = true    # free — TAXII feeds

# Playbooks
teams_webhook_url  = ""   # configure post-deployment
notification_email = ""   # configure post-deployment

# Log Analytics retention
log_retention_days         = 90    # 90 = NIS2 minimum, 365 = DORA
log_archive_retention_days = 730   # cold storage archival
```

### Step 2 — Deploy

```bash
terraform init
terraform plan -var-file=terraform.tfvars    # always review first
terraform apply -var-file=terraform.tfvars
```

### Step 3 — Post-deployment checklist

After `terraform apply` succeeds, these manual steps are required:

- [ ] **Activate UEBA** — Sentinel > Settings > Entity behavior analytics > Turn on (not Terraform-deployable)
- [ ] **Configure playbook webhooks** — Logic Apps > Edit > Set Teams/Slack webhook URL
- [ ] **Install Content Hub solutions** — Sentinel > Content Hub > Install solutions for your data sources
- [ ] **Wait 14-21 days** for UEBA behavioral baselines to build
- [ ] **Review analytics rules** — Tune thresholds and frequencies after 7 days of real data
- [ ] **Adjust Commitment Tier** — After 30 days, check average daily ingestion and switch to commitment tier if > 100 GB/day
- [ ] **Enable Defender for Cloud** — If licenses are available, activate Defender plans per subscription

## Important Notes

- This stack deploys **infrastructure only** — it does not modify your Entra ID tenant, your Microsoft 365 configuration, or any existing resources
- Data connectors **read** from your sources — they do not write to or modify them
- Playbooks execute with a **dedicated Managed Identity** — configure RBAC scoped to what each playbook needs
- Analytics rules generate **incidents**, not automated responses (unless you enable auto-block playbooks in premium tier)
- Always run `terraform plan` before `terraform apply` — verify zero unintended changes

## Cost Estimates

| Tier | Estimated Ingestion | Estimated Monthly Cost |
|------|---------------------|------------------------|
| Basic | 1-5 GB/day | 100-500 EUR/month |
| Standard | 5-20 GB/day | 500-2,500 EUR/month |
| Premium | 20-100 GB/day | 2,500-10,000 EUR/month |

*Costs depend primarily on ingestion volume. Commitment tiers (100+ GB/day) offer significant discounts.*

## Validation Status

> **⚠️ This stack is in development. It has NOT been tested on a live Azure environment yet.**

| Phase | Status |
|-------|--------|
| Terraform validate/plan | ⏳ Pending |
| Terraform apply (lab) | ⏳ Pending |
| Data connectors verified | ⏳ Pending |
| KQL queries tested | ⏳ Pending |
| Playbooks tested | ⏳ Pending |
| Multi-tier tested (basic/standard/premium) | ⏳ Pending |
| Cost estimates verified | ⏳ Pending |
| Checkov 0 failed | ⏳ Pending |

This stack will NOT be integrated into the AethronOps engine or made available for purchase until all phases are validated. See `docs/SENTINEL-SOC-GUIDE.md` section 10 for the full test plan.

## Disclaimer

AethronOps templates are aligned with Microsoft best practices and compliance frameworks. They do not constitute a compliance certification. Users are responsible for validating their deployments against their own regulatory requirements. Always run `terraform plan` before applying any changes to production environments.

---

**[View all stacks](https://aethronops.com/stacks) · [Generate this stack](https://aethronops.com/stacks/sentinel-soc-baseline)**
