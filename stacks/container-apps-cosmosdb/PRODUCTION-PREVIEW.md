# container-apps-cosmosdb — Production Preview

> **This is the open-source DEV variant.** Production is sold separately at [aethronops.com/stacks/container-apps-cosmosdb/](https://aethronops.com/stacks/container-apps-cosmosdb/).

## What's in this folder (free, MIT)

The dev variant: standalone, public access, perfect for prototyping. Fill `envs/dev.tfvars` and `terraform apply` — no other prereqs.

## What you get with the production variant (paid — 199 € HT or 499 € All-Access)

A full enterprise-grade stack — the kind that costs your team weeks to wire by hand:

- **10 Azure Verified Modules** wiring **39 Terraform resources** end-to-end
- **16 `.tf` files · 1,346 effective HCL lines** (no copy-paste of generic templates — each resource is intentional)
- **Brownfield-ready** with three modes (Mode A: AethronOps Platform Baseline, Mode B: your existing VNet, Mode C: lookup by name)

### Compute & data

- **Container Apps** wired to a shared VNet with delegated subnet, autoscale, VNet integration, MI attached
- **Azure Cosmos DB (NoSQL API)** — TLS 1.3, Zone HA optional, 7–35d backup, audit logging, post-deploy bootstrap (database, extensions, Entra admin group)
- **Auto-built connection string** — assembled from DB host + admin login + generated password, stored as Key Vault secret, consumed by Container Apps via `@Microsoft.KeyVault()` reference. No password ever in app config.


### Identity & secrets

- **User-Assigned Managed Identity** with **4 role assignments** (KV Secrets User, Storage Blob Data Contributor, Monitoring Metrics Publisher, Log Analytics Reader, RG Reader)
- **Entra DB admins group** — passwordless authentication via Entra ID. The MI is added as a member of the group, configured as the database Entra admin
- **Key Vault** with RBAC, soft-delete 90d, purge protection, network ACLs, Private Endpoint
- **DevOps team roles** (opt-in) — Website Contributor + Web Plan Contributor + KV Secrets Officer

### Network

- **Private Endpoints** on Key Vault, Storage — DNS auto-registered in the platform Private DNS Zones
- **Public network access disabled** on every backend
- **VNet integration** — outbound traffic routes through NAT Gateway → static egress IPs (no SNAT exhaustion)

### Monitoring

- **6 recommended Cosmos DB alerts** routed to email action group (CPU, memory, storage, connections, deadlocks, IOPS where applicable)
- **Key Vault secret expiry alert** via EventGrid → 30-day pre-expiry warning
- **Diagnostic settings on every resource** → Log Analytics centralized (configurable retention 30/90/180/365 days)

### FinOps

- **Budget alerts** at 50/75/90/100% with email notifications
- **Storage lifecycle** — auto-tier to Cool after 30d, Archive after 90d (up to 80% cost reduction on cold data)
- **PaaS auto-shutdown** (opt-in) — Automation Account + PowerShell runbooks for off-hours scheduling, up to 60% savings on non-prod

### Governance

- **Management locks** (opt-in, post-deploy) — `CanNotDelete` on the primary resources to prevent `rm -rf` accidents
- **4 Azure Policy assignments** (Audit mode by default, switchable to Deny) — allowed locations, required tags, audit diagnostic settings, Storage secure transfer
- **Microsoft Defender for Cloud** plans (opt-in) — Defender for App Service / SQL / Storage / KV


### Compliance posture

`SECURITY-POSTURE.md` documents **61 controls mapped** across **4 frameworks** (MCSB · CAF · WAF · GDPR/RGPD), with traceability to NIS2, DORA, CIS, ISO 27001, SOC 2 and PCI-DSS where applicable. Aligned with these frameworks — not a certification, not a guarantee.

## AVM modules used

| Module | Source | Version (pinned) |
|---|---|---|
| `application_insights` | `Azure/avm-res-insights-component/azurerm` | `0.3.0` |
| `container_app` | `Azure/avm-res-app-containerapp/azurerm` | `~> 0.7` |
| `container_app_environment` | `Azure/avm-res-app-managedenvironment/azurerm` | `~> 0.4` |
| `cosmosdb_account` | `Azure/avm-res-documentdb-databaseaccount/azurerm` | `~> 0.10` |
| `key_vault` | `Azure/avm-res-keyvault-vault/azurerm` | `~> 0.10` |
| `log_analytics` | `Azure/avm-res-operationalinsights-workspace/azurerm` | `~> 0.4` |
| `managed_identity` | `Azure/avm-res-managedidentity-userassignedidentity/azurerm` | `~> 0.3` |
| `private_endpoint_cosmos` | `Azure/avm-res-network-privateendpoint/azurerm` | `0.2.0` |
| `resource_group` | `Azure/avm-res-resources-resourcegroup/azurerm` | `~> 0.2` |
| `storage_account` | `Azure/avm-res-storage-storageaccount/azurerm` | `~> 0.2` |

All modules: `enable_telemetry = false`. Provider constraints: `azurerm ~> 4.64`, `azapi ~> 2.4`.

## Use cases

Ideal for event-driven microservices, distributed apps.

---

**Buy production:** [aethronops.com/stacks/container-apps-cosmosdb/](https://aethronops.com/stacks/container-apps-cosmosdb/) · 199 € HT (Single) or 499 € HT (All-Access, all 11 stacks)
