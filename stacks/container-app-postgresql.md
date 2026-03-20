# Container Apps + PostgreSQL

Azure Container Apps with PostgreSQL Flexible Server, built-in PgBouncer connection pooling, Key Vault, Managed Identity, and private networking. Production-ready microservices platform with managed database.

**Compliance:** CAF · WAF · MCSB · RGPD · NIS2

## Azure Components

- Resource Group
- Container Apps Environment (Workload Profiles)
- Container App
- PostgreSQL Flexible Server (with PgBouncer)
- Managed Identity (User-Assigned)
- Key Vault
- Log Analytics Workspace
- Application Insights
- Storage Account
- Virtual Network + Subnets (CAE, DB, PE, mgmt)
- NAT Gateway
- Network Security Group (NSG)
- Private Endpoint (PostgreSQL, Key Vault, ACR)
- Private DNS Zone
- Azure Container Registry
- Backup Vault

## Available Tiers

- **Basic** (~8 resources) — Container Apps (Consumption) + PostgreSQL B1ms + Key Vault + Managed Identity + Log Analytics + Storage. Public access, no VNet, no PgBouncer. For dev/POC.
- **Standard** (~15 resources) — Adds Workload Profiles, PostgreSQL GP D2s_v3 with PgBouncer, VNet isolation, NAT Gateway, Private Endpoints, NSG, ACR with PE. For production workloads.
- **Premium** (~22 resources) — Zone-redundant PostgreSQL HA, zone-redundant CAE, Backup Vault, advanced monitoring, full network isolation. For enterprise and NIS2/DORA compliance.

## What You Get

A complete Terraform project (ZIP) with:

- Multi-file structure (networking.tf, identity.tf, monitoring.tf, database.tf, container.tf, etc.)
- Azure Verified Modules (AVM) — Microsoft's official Terraform modules
- Pre-configured `terraform.tfvars` for your chosen tier
- PgBouncer connection pooling pre-configured (standard/premium)
- Managed Identity authentication to PostgreSQL (no password in connection string)
- OpenTelemetry-ready monitoring configuration
- Container Apps Jobs template for database migrations
- Compliance report (COMPLIANCE.md) with MCSB, RGPD Art. 32, and NIS2 Art. 21(2) mappings
- Checkov security scanning configuration
- README with deployment guide

## Prerequisites

Before deploying, ensure your environment meets these requirements:

### Azure Subscription
- Resource providers registered:
  - `Microsoft.App`
  - `Microsoft.DBforPostgreSQL`
  - `Microsoft.ContainerRegistry`
- Service Principal or Managed Identity with `Contributor` role on the target Resource Group

### Container Image
- A container image available in ACR (or a public image for initial testing)
- For PgBouncer: PostgreSQL **General Purpose** tier or higher is required (NOT Burstable B1ms)

## Deployment Guide

### Step 1 — Configure variables

```hcl
# terraform.tfvars — key variables
project          = "myapp"
environment      = "prd"
location         = "westeurope"

# Container Apps
container_image  = "myregistry.azurecr.io/myapp:latest"
container_port   = 8080
container_cpu    = 0.5
container_memory = "1Gi"

# PostgreSQL
postgresql_sku_name    = "GP_Standard_D2s_v3"   # GP required for PgBouncer
enable_pgbouncer       = true
postgresql_storage_mb  = 32768

# Networking (standard/premium)
enable_private_endpoints = true
```

### Step 2 — Deploy

```bash
terraform init
terraform plan -var-file=terraform.tfvars    # always review first
terraform apply -var-file=terraform.tfvars
```

### Step 3 — Post-deployment checklist

After `terraform apply` succeeds, these manual steps are required:

- [ ] **Push container image to ACR** — `az acr login --name <registry>` then `docker push`
- [ ] **Configure container app revision** — Update image tag in `terraform.tfvars` and re-apply, or use `az containerapp update`
- [ ] **Verify database connectivity** — Check container logs for successful PostgreSQL connection
- [ ] **Set up CI/CD pipeline** — Configure GitHub Actions or Azure DevOps for automated image builds and deployments
- [ ] **Configure custom domain** — If needed, add custom domain and TLS certificate to Container App ingress

## Important Notes

- **PgBouncer availability** — PgBouncer is ONLY available on General Purpose and Memory Optimized tiers. It is NOT supported on Burstable (B1ms). The basic tier uses direct PostgreSQL connections.
- **Subnet sizing** — Container Apps Environment subnet cannot be resized after creation. Plan your IP address space carefully (/23 recommended minimum for production).
- **Application Insights** — Container Apps does NOT have auto-instrumentation for Application Insights. You must include the OpenTelemetry SDK in your container image to collect traces and metrics.
- **Managed Identity for PostgreSQL** — Connection via Managed Identity requires the `azure.extensions` server parameter set to `AZURE_AD`. This is configured automatically by the stack.
- Always run `terraform plan` before `terraform apply` — verify zero unintended changes.

## Cost Estimates

| Tier | Estimated Monthly Cost |
|------|------------------------|
| Basic | ~20 EUR/month (Consumption plan + PostgreSQL B1ms) |
| Standard | ~200 EUR/month (Workload profiles + PostgreSQL GP D2s_v3 + PgBouncer) |
| Premium | ~600 EUR/month (Zone redundant + PostgreSQL GP D4s_v3 HA + Backup) |

*Costs depend on container replicas, CPU/memory allocation, and database storage. Consumption plan billing is per-request; Workload Profiles are per-vCPU-second.*

## Validation Status

> **This stack is in development. It has NOT been tested on a live Azure environment yet.**

| Phase | Status |
|-------|--------|
| Terraform validate/plan | Pending |
| Terraform apply (lab) | Pending |
| Container App deployment verified | Pending |
| PgBouncer connectivity tested | Pending |
| Managed Identity auth verified | Pending |
| Multi-tier tested (basic/standard/premium) | Pending |
| Cost estimates verified | Pending |
| Checkov 0 failed | Pending |

This stack will NOT be integrated into the AethronOps engine or made available for purchase until all phases are validated.

## Disclaimer

AethronOps templates are aligned with Microsoft best practices and compliance frameworks. They do not constitute a compliance certification. Users are responsible for validating their deployments against their own regulatory requirements. Always run `terraform plan` before applying any changes to production environments.

---

**[View all stacks](https://aethronops.com/stacks) · [Generate this stack](https://aethronops.com/stacks/container-app-postgresql)**
