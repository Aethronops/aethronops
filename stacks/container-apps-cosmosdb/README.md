# container-apps-cosmosdb — Dev

<!-- Badges -->
![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.9-844FBA?logo=terraform&logoColor=white)
![AVM](https://img.shields.io/badge/Azure%20Verified%20Modules-7%20modules-0078D4?logo=microsoftazure&logoColor=white)
![Resources](https://img.shields.io/badge/Terraform%20Resources-22-844FBA)
![Tier](https://img.shields.io/badge/Tier-dev-blue)
![Frameworks](https://img.shields.io/badge/Frameworks-CAF%20%7C%20MCSB%20%7C%20NIS2%20%7C%20RGPD%20%7C%20WAF-success)
![Mode](https://img.shields.io/badge/Mode-standalone-lightgrey)

> **Cost & Performance** — ~€15-30/month, deploys in 5-8 minutes, 22 Terraform resources.

> **AethronOps** — Azure infrastructure aligned with security best practices.
> All resources use [Azure Verified Modules (AVM)](https://aka.ms/avm), officially maintained by Microsoft.

> [!WARNING]
> **This code is provided "AS IS".** It must be reviewed and validated by a qualified person
> (DevOps, Cloud Architect, security team) before any deployment. Never deploy to production
> without testing in dev/uat first. **AethronOps is not responsible for any Azure costs,
> security incidents, data loss, outages, or regulatory non-compliance resulting from
> deploying this code.** See the Disclaimer section below.

> **Deployment Mode: Standalone**
>
> This stack is self-contained. All required resources (networking, monitoring, security, identity)
> are created within this deployment. No external prerequisites — deploy it in any Resource Group
> on any Azure subscription and it will work independently.
>
> For enterprise environments with centralized governance (Hub-Spoke, shared Log Analytics,
> central Key Vault), switch to **corp** mode to consume these resources via brownfield
> instead of recreating them.

---

## Usage

```hcl
module "container_apps_cosmosdb" {
  source  = "aethronops/container-apps-cosmosdb/azurerm"
  version = "~> 3.0"

  subscription_id = "00000000-0000-0000-0000-000000000000"
  project_name    = "myapp"  # max 8 chars, lowercase + hyphens only
  environment     = "dev"
  location        = "francecentral"
  region_short    = "frc"
}
```

**Full installation guide:** [INSTALL.md](./INSTALL.md)


## Architecture

| | |
|---|---|
| **Pattern** | `container-apps-cosmosdb` |
| **Tier** | dev (Dev) |
| **AVM Modules** | 7 Azure Verified Modules |
| **Terraform Resources** | 22 resources deployed |
| **Region** | `francecentral` |

---

## Components

<details open>
<summary><strong>What each resource does and how it is secured</strong> (7 modules, 22 resources)</summary>

| Resource | Purpose | Security |
|:---------|:--------|:---------|
| **Resource Group** | Logical container for all resources — enables unified RBAC, tagging, billing, and lifecycle management. | CAF naming convention, tag inheritance, RBAC scoping |
| **Log Analytics** | Central logging and monitoring — all services send diagnostic logs here. | 30-day retention, query-based alerts, SIEM-ready export (MCSB LT-1/LT-5) |
| **Managed Identity** | Passwordless authentication for all services — no credentials to manage or rotate. | User-assigned identity, RBAC least-privilege, no shared keys (MCSB IM-1) |
| **Key Vault** | Centralized secrets, keys, and certificates management. | RBAC authorization, soft-delete enabled, purge protection, network ACLs (MCSB DP-1/DP-3) |
| **Container Apps Environment** | Shared environment for Container Apps — networking and logging. | VNet integration, Log Analytics connected, internal-only option in premium |
| **Container App** | Serverless container execution — HTTP-triggered or background processing. | Managed identity, ingress TLS, VNet integration, secret management (MCSB NS-3) |
| **Cosmos DB** | Globally distributed NoSQL database — multi-model, multi-region, low-latency. | Managed Identity, encryption at rest, network isolation in premium (MCSB DP-1/NS-3) |

</details>

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
# In envs/<env>.tfvars:
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
| `envs/<env>.tfvars` | Selected tier variable values |
| `SECURITY-POSTURE.md` | Security controls mapping (audit preparation aid) |
| `.checkov.yaml` | Security scan configuration |

---

## Security

> [!IMPORTANT]
> All modules are [Azure Verified Modules](https://aka.ms/avm) — officially maintained by Microsoft.
> Security framework references (CAF, MCSB, GDPR, NIS2) are documented in each `.tf` file header as an audit preparation aid.
> See `SECURITY-POSTURE.md` for the detailed security controls mapping.

---

## Sources

> All modules are [Azure Verified Modules (AVM)](https://aka.ms/avm), maintained by Microsoft. Versions pinned at generation time.

| Component | Module | Version | Link |
|:----------|:-------|:--------|:-----|
| resource-group | `Azure/avm-res-resources-resourcegroup/azurerm` | `~> 0.2` | [Registry](https://registry.terraform.io/modules/Azure/avm-res-resources-resourcegroup/azurerm) |
| log-analytics | `Azure/avm-res-operationalinsights-workspace/azurerm` | `~> 0.4` | [Registry](https://registry.terraform.io/modules/Azure/avm-res-operationalinsights-workspace/azurerm) |
| managed-identity | `Azure/avm-res-managedidentity-userassignedidentity/azurerm` | `~> 0.3` | [Registry](https://registry.terraform.io/modules/Azure/avm-res-managedidentity-userassignedidentity/azurerm) |
| key-vault | `Azure/avm-res-keyvault-vault/azurerm` | `~> 0.10` | [Registry](https://registry.terraform.io/modules/Azure/avm-res-keyvault-vault/azurerm) |
| container-app-environment | `Azure/avm-res-app-managedenvironment/azurerm` | `~> 0.4` | [Registry](https://registry.terraform.io/modules/Azure/avm-res-app-managedenvironment/azurerm) |
| container-app | `Azure/avm-res-app-containerapp/azurerm` | `~> 0.7` | [Registry](https://registry.terraform.io/modules/Azure/avm-res-app-containerapp/azurerm) |
| cosmosdb-account | `Azure/avm-res-documentdb-databaseaccount/azurerm` | `~> 0.10` | [Registry](https://registry.terraform.io/modules/Azure/avm-res-documentdb-databaseaccount/azurerm) |

| Provider | Version | Purpose |
|:---------|:--------|:--------|
| `hashicorp/azurerm` | `~> 4.0` | Azure Resource Manager |
| `Azure/azapi` | `~> 2.4` | Azure API (advanced resources) |
| `hashicorp/random` | `~> 3.6` | Random strings (storage naming) |

---

## Upgrade to Production

This dev tier is optimised for quick starts and low cost. The production tier adds:

- **Private Endpoints** for all PaaS (zero egress to the public internet)
- **Azure Policy** assignments (audit mode, aligned with CAF / MCSB)
- **Backup Vault** long-term retention (up to 10 years)
- **Hardened Storage** with private access only
- **Platform integration** (Mode A/B/C — wire into existing Azure hub infrastructure)
- **~240 lines of `governance.tf`** (resource locks, policy enforcement)
- **Preconditions** validated at plan time

See the production tier on [aethronops.com](https://aethronops.com).

---
## Disclaimer

This Terraform code is provided **"AS IS"** without warranty of any kind. AethronOps provides
technical foundations **aligned with** security frameworks (MCSB, CAF, RGPD, NIS2...) but
**does not certify, attest, or guarantee compliance**. Regulatory compliance requires formal
audits by accredited assessors.

- AethronOps **does not access** your Azure environment, your repo, or your credentials.
- **No warranty** — you are solely responsible for deployment and Azure costs.
- **Mandatory review** — review all `.tf` files and `envs/<env>.tfvars` before deploying.
- **No legal advice** — consult qualified legal counsel for regulatory matters.

*See terms and conditions at [aethronops.com/legal](https://aethronops.com/legal) for full legal notices.*

---

<p align="center">
<sub>Generated by <strong>AethronOps v3</strong> — 7 modules AVM, 22 Terraform resources, dev tier</sub>
</p>
