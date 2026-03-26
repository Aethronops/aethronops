# governance-subscription — Production

<!-- Badges -->
![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.9-844FBA?logo=terraform&logoColor=white)
![AVM](https://img.shields.io/badge/Azure%20Verified%20Modules-8%20modules-0078D4?logo=microsoftazure&logoColor=white)
![Resources](https://img.shields.io/badge/Terraform%20Resources-21-844FBA)
![Tier](https://img.shields.io/badge/Tier-standard-orange)
![Frameworks](https://img.shields.io/badge/Frameworks-CAF%20%7C%20DORA%20%7C%20MCSB%20%7C%20NIS2%20%7C%20RGPD%20%7C%20WAF-success)
![Mode](https://img.shields.io/badge/Mode-standalone-lightgrey)

> **AethronOps** — Azure infrastructure aligned with security best practices.
> All resources use [Azure Verified Modules (AVM)](https://aka.ms/avm), officially maintained by Microsoft.

> [!WARNING]
> **This code is provided "AS IS".** It must be reviewed and validated by a qualified person
> (DevOps, Cloud Architect, security team) before any deployment. Never deploy to production
> without testing in dev/uat first. **AethronOps is not responsible for any Azure costs,
> security incidents, data loss, outages, or regulatory non-compliance resulting from
> deploying this code.** See the Disclaimer section below.

> **Deployment Mode: Standalone** (quick-start)
>
> This stack is in standalone quick-start mode. All resources (networking, monitoring, security)
> are self-contained. For production environments with centralized governance, deploy
> `platform-connectivity` first and switch to **corp** mode to leverage shared Hub resources.

---

## Architecture

| | |
|---|---|
| **Pattern** | `governance-subscription` |
| **Tier** | standard (Production) |
| **AVM Modules** | 8 Azure Verified Modules |
| **Terraform Resources** | 21 resources deployed |
| **Region** | `westeurope` |

---

## Components

<details open>
<summary><strong>What each resource does and how it is secured</strong> (8 modules, 21 resources)</summary>

| Resource | Purpose | Security |
|:---------|:--------|:---------|
| **Resource Group** | Logical container for all resources — enables unified RBAC, tagging, billing, and lifecycle management. | CAF naming convention, tag inheritance, RBAC scoping |
| **Log Analytics** | Central logging and monitoring — all services send diagnostic logs here. | 30-day retention, query-based alerts, SIEM-ready export (MCSB LT-1/LT-5) |
| **Managed Identity** | Passwordless authentication for all services — no credentials to manage or rotate. | User-assigned identity, RBAC least-privilege, no shared keys (MCSB IM-1) |
| **subscription-diagnostic** | subscription-diagnostic | See .tf file header |
| **subscription-budget** | subscription-budget | See .tf file header |
| **security-contact** | security-contact | See .tf file header |
| **defender-plans** | defender-plans | See .tf file header |
| **rbac-assignments** | rbac-assignments | See .tf file header |

</details>

---

## Quick Start

### 1. Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.9
- An Azure subscription with **Contributor** role on the target Resource Group (or subscription-level if the stack creates the Resource Group)
- Azure CLI authenticated: `az login`

### 2. Configure Your Environment

Edit `terraform.tfvars` at the root of the stack:

```bash
# Change these values in terraform.tfvars:
#   project_name    = "your-project-name"
#   Note: subscription_id is auto-detected from ARM_SUBSCRIPTION_ID env var
```


### 3. Deploy

> [!CAUTION]
> **NEVER deploy directly to production.** This code MUST be reviewed and validated by
> qualified person (DevOps engineer, Cloud Architect, or security team) before any deployment.
> Always test in dev/uat first, review `terraform plan` output carefully,
> and get written approval from your RSSI/DPO before any production deployment.
> **You are solely responsible for resources deployed in your Azure environment.**
> AethronOps is not responsible for any costs, incidents, or damages resulting from deployment.
> See the Disclaimer section below.

```bash
# Initialize Terraform (downloads AVM modules)
terraform init

# Preview what will be created — ALWAYS review before applying
terraform plan -var-file=terraform.tfvars

# Deploy — ALWAYS review the plan before applying
terraform apply -var-file=terraform.tfvars
```

### 4. Tier Values

Values in `terraform.tfvars` correspond to your chosen tier (**standard**).
Adapt retention, SKU, and network settings to your needs.

| Setting | basic | standard | premium |
|:--------|:------|:---------|:--------|
| **Log retention** | 30 days | 90 days (MCSB LT-6) | 365 days (NIS2/DORA) |
| **Storage replication** | LRS | ZRS | GZRS |
| **Public access** | Enabled | Disabled (MCSB NS-2) | Disabled (MCSB NS-2) |

### 5. Remote State (recommended for teams)

```bash
cp backend.tf.example backend.tf
# Edit backend.tf with your storage account details
terraform init -migrate-state
```

---

## Enterprise Customization

<details>
<summary><strong>Extend this stack with your organization's policies</strong></summary>

| Customization | How |
|:--------------|:----|
| **Custom tags** | Add mandatory tags in `custom_tags` variable (cost center, business unit...) |
| **Network policies** | Set `require_private_endpoints = true` for zero-trust networking |
| **VNet capacity** | Each full stack creates 2-4 Private Endpoints. Azure limit is 1,000 PE per VNet |
| **Checkov policies** | Add your rules in `.checkov.yaml` or `custom_checks/` directory |
| **Azure Policy** | Add assignments in a `custom_policies.tf` file (not overwritten by AethronOps) |

See `SECURITY-POSTURE.md` for the full security controls mapping with space for your enterprise requirements.

</details>

---

## FinOps — Cost Optimization Settings

<details>
<summary><strong>How to enable, disable, or customize each FinOps feature</strong></summary>

All FinOps resources are in `finops.tf`. Each feature has a dedicated toggle variable.

### Global On/Off

| Variable | Default | Effect |
|:---------|:--------|:-------|
| `enable_finops` | `true` | Master switch — disables ALL FinOps resources when `false` |

### Budget Alerts

| Variable | Default | Effect |
|:---------|:--------|:-------|
| `monthly_budget_eur` | `50`/`200`/`1000` (dev/uat/prod) | Monthly budget threshold in EUR |
| `budget_alert_emails` | `[]` | Email recipients (alerts fire at 50%, 80%, 100%, 120%) |
| `finops_webhook_url` | `""` | Optional Teams/Slack webhook for alerts |

To disable budget alerts: set `budget_alert_emails = []`.

### Removing FinOps Entirely

If you don't want any FinOps resources:

```hcl
# In terraform.tfvars:
enable_finops = false
```

This sets `count = 0` on all FinOps resources. No Automation Account, no budget alerts, no lifecycle policies.
You can also safely delete the `finops.tf` file entirely — no other file depends on it.

</details>


## Integrating into an Existing Project

<details>
<summary><strong>Option A — Use this stack as-is</strong> (recommended)</summary>

Deploy this stack as a separate Terraform workspace. It creates its own Resource Group, VNet, and supporting services. Your existing infrastructure is not affected.

</details>

<details>
<summary><strong>Option B — Cherry-pick specific files</strong></summary>

Each `.tf` file is independent. Copy the files you need into your project and adapt the references:
- Replace `module.resource_group.name` with your own resource group name
- Replace `module.key_vault.resource_id` with your own Key Vault ID
- Replace `module.log_analytics.resource.id` with your own Log Analytics workspace ID

> [!NOTE]
> If you rewrite AVM modules as native `azurerm` resources, you are responsible for implementing the equivalent security configuration. AethronOps validates only the AVM-based code provided in this stack. See the Sources section below for the exact modules used.

</details>

<details>
<summary><strong>Brownfield — Use existing infrastructure</strong></summary>

If you already have a VNet, Key Vault, or Log Analytics workspace, reference them instead of creating new ones:

```hcl
# Example: use an existing VNet (in networking.tf)
data "azurerm_virtual_network" "existing" {
  name                = "vnet-enterprise-prod-weu"
  resource_group_name = "rg-network-prod-weu"
}
# Then reference: data.azurerm_virtual_network.existing.id
```

| Replace this module | With this data source |
|:--------------------|:----------------------|
| `module "virtual_network"` | `data "azurerm_virtual_network"` |
| `module "key_vault"` | `data "azurerm_key_vault"` |
| `module "log_analytics"` | `data "azurerm_log_analytics_workspace"` |
| `module "resource_group"` | `data "azurerm_resource_group"` |

</details>

---

## File Structure

| File | Purpose |
|:-----|:--------|
| `main.tf` | Terraform config, providers, locals |
| `resource_group.tf` | Resource group (CAF naming) |
| `*.tf` (domain files) | One file per functional domain |
| `variables.tf` | Input variables with validation |
| `outputs.tf` | Useful outputs (IDs, endpoints) |
| `terraform.tfvars` | Selected tier variable values |
| `SECURITY-POSTURE.md` | Security controls mapping (audit preparation aid) |
| `.checkov.yaml` | Security scan configuration |

---

## Security

> [!IMPORTANT]
> All modules are [Azure Verified Modules](https://aka.ms/avm) — officially maintained by Microsoft.
> Security framework references (CAF, MCSB, RGPD, NIS2) are documented in each `.tf` file header as an audit preparation aid.
> See `SECURITY-POSTURE.md` for the detailed security controls mapping.

---

## Sources

> All modules are [Azure Verified Modules (AVM)](https://aka.ms/avm), maintained by Microsoft. Versions pinned at generation time.

| Component | Module | Version | Link |
|:----------|:-------|:--------|:-----|
| resource-group | `Azure/avm-res-resources-resourcegroup/azurerm` | `~> 0.2` | [Registry](https://registry.terraform.io/modules/Azure/avm-res-resources-resourcegroup/azurerm) |
| log-analytics | `Azure/avm-res-operationalinsights-workspace/azurerm` | `~> 0.4` | [Registry](https://registry.terraform.io/modules/Azure/avm-res-operationalinsights-workspace/azurerm) |
| managed-identity | `Azure/avm-res-managedidentity-userassignedidentity/azurerm` | `~> 0.3` | [Registry](https://registry.terraform.io/modules/Azure/avm-res-managedidentity-userassignedidentity/azurerm) |
| subscription-diagnostic | `` (native) | azurerm ~> 4.0 | [Provider docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest) |
| subscription-budget | `` (native) | azurerm ~> 4.0 | [Provider docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest) |
| security-contact | `` (native) | azurerm ~> 4.0 | [Provider docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest) |
| defender-plans | `` (native) | azurerm ~> 4.0 | [Provider docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest) |
| rbac-assignments | `` (native) | azurerm ~> 4.0 | [Provider docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest) |

| Provider | Version | Purpose |
|:---------|:--------|:--------|
| `hashicorp/azurerm` | `~> 4.0` | Azure Resource Manager |
| `Azure/azapi` | `~> 2.4` | Azure API (advanced resources) |
| `hashicorp/random` | `~> 3.6` | Random strings (storage naming) |

---

## Disclaimer

This Terraform code is provided **"AS IS"** without warranty of any kind. AethronOps provides
technical foundations **aligned with** security frameworks (MCSB, CAF, RGPD, NIS2...) but
**does not certify, attest, or guarantee compliance**. Regulatory compliance requires formal
audits by accredited assessors.

- AethronOps **does not access** your Azure environment, your repo, or your credentials.
- **No warranty** — you are solely responsible for deployment and Azure costs.
- **Mandatory review** — review all `.tf` files and `terraform.tfvars` before deploying.
- **No legal advice** — consult qualified legal counsel for regulatory matters.

*See terms and conditions at [aethronops.com](https://aethronops.com) for full legal notices.*

---

<p align="center">
<sub>Generated by <strong>AethronOps v2</strong> — 8 modules AVM, 21 Terraform resources, standard tier</sub>
</p>

---

## Estimated Azure Costs — westeurope (EUR)

**Tier:** standard

| Resource | Description | Unit Price | Estimated Monthly |
|----------|-------------|------------|-------------------|
| resource-group | Resource Groups are free. | Free | 0 EUR |
| log-analytics | Data ingestion (5 GB/month free); Retention beyond 31 days | 2.5336 EUR/GB | 0 — 31 EUR |
| managed-identity | Managed Identity is free. | Free | 0 EUR |
| subscription-diagnostic | Diagnostic settings are free. Log ingestion cost is on Lo... | Free | 0 EUR |
| subscription-budget | Budget alerts are free. | Free | 0 EUR |
| security-contact | Security contact configuration is free. | Free | 0 EUR |
| defender-plans | VMs P1 + Storage + KV + SQL + OSS DB — Servers P1; Storag... | 0.0057 EUR/hours | 25 — 25 EUR |
| rbac-assignments | RBAC assignments are free. | Free | 0 EUR |
| **Total** | | | **25 — 56 EUR/month** |

### Hidden costs to watch

| Cost | Detail | Typical range |
|------|--------|---------------|
| Bandwidth egress (after 100 GB free) | 0.0678 EUR/GB | 5-50 EUR/month |
| Storage transactions (read/write/list) | ~0.005 EUR/10K operations | 1-10 EUR/month |
| VNet Peering intra-region | 0.0085 EUR/GB each direction | 0.5-5 EUR/month |
| Inter-region data transfer | 0.017 EUR/GB | 1-20 EUR/month |
| Log Analytics Basic logs query | 0.006 EUR/GB scanned | 0-5 EUR/month |

> Prices from Azure Retail API (2026-03-26). Actual costs depend on usage.
> Free tier: 5 GB/month.

---

# SLA Composite — AethronOps

**Tier** : standard
**Briques** : 8 (5 impactant le SLA)

## Détail par brique

| Brique | SLA (%) | Note |
|--------|---------|------|
| `resource-group` | 100% (pas d'impact) | Ressource gratuite, pas de SLA applicable |
| `log-analytics` | 99.90% | SLA Azure Monitor Log Analytics |
| `managed-identity` | 99.99% | Azure Active Directory / Entra ID SLA |
| `subscription-diagnostic` | 99.90% | SLA inconnu — valeur conservative 99.9% |
| `subscription-budget` | 100% (pas d'impact) | Plan de contrôle Azure — pas d'impact SLA |
| `security-contact` | 100% (pas d'impact) | Plan de contrôle Azure — pas d'impact SLA |
| `defender-plans` | 99.90% | SLA Microsoft Defender for Cloud |
| `rbac-assignments` | 99.90% | SLA inconnu — valeur conservative 99.9% |

## SLA Composite

**SLA composite** : **99.5906%**
**Classe de disponibilité** : two nines (99%)

**Formule** : 99.90% × 99.99% × 99.90% × 99.90% × 99.90% = 99.5906%

## Temps d'indisponibilité estimé

| Période | Downtime |
|---------|----------|
| Par mois | 176.84 minutes |
| Par an | 2153.07 minutes (35.88 heures) |

---
*Source : Microsoft Azure SLA documentation — https://azure.microsoft.com/en-us/support/legal/sla/*
