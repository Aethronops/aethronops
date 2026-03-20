# Container Apps + SQL Database

Azure Container Apps with Azure SQL Database, Key Vault, Managed Identity, and private networking. Production-ready microservices platform with Microsoft's flagship relational database.

**Compliance:** CAF · WAF · MCSB · RGPD · NIS2

## Azure Components

- Resource Group
- Container Apps Environment (Workload Profiles)
- Container App
- SQL Server (logical server)
- SQL Database
- Managed Identity (User-Assigned)
- Key Vault
- Log Analytics Workspace
- Application Insights
- Storage Account
- Virtual Network + Subnets (CAE, PE, mgmt)
- NAT Gateway
- Network Security Group (NSG)
- Private Endpoint (SQL, Key Vault, ACR)
- Private DNS Zone
- Azure Container Registry
- Backup Vault

## Available Tiers

- **Basic** (~8 resources) — Container Apps (Consumption) + SQL Database Basic 5 DTU + Key Vault + Managed Identity + Log Analytics + Storage. Public access, no VNet. For dev/POC.
- **Standard** (~15 resources) — Adds Workload Profiles, SQL Database GP S-series 2 vCores serverless, VNet isolation, NAT Gateway, Private Endpoints, NSG, ACR with PE. For production workloads.
- **Premium** (~22 resources) — Zone-redundant SQL Database BC 4 vCores, zone-redundant CAE, failover group, Backup Vault, advanced monitoring, full network isolation. For enterprise and NIS2/DORA compliance.

## What You Get

A complete Terraform project (ZIP) with:

- Multi-file structure (networking.tf, identity.tf, monitoring.tf, database.tf, container.tf, etc.)
- Azure Verified Modules (AVM) — Microsoft's official Terraform modules
- Pre-configured `terraform.tfvars` for your chosen tier
- TDE (Transparent Data Encryption) enabled by default — encryption at rest for free
- Managed Identity authentication to SQL Database (Entra ID admin on SQL Server)
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
  - `Microsoft.Sql`
  - `Microsoft.ContainerRegistry`
- Service Principal or Managed Identity with `Contributor` role on the target Resource Group

### Container Image
- A container image available in ACR (or a public image for initial testing)

### SQL Database Managed Identity Auth
- Entra ID admin must be set on the SQL Server (configured by the stack)
- Post-deployment: run `CREATE USER [identity-name] FROM EXTERNAL PROVIDER` on the database to grant access to the Managed Identity — this step is NOT Terraform-deployable

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

# SQL Database
sql_sku_name           = "GP_S_Gen5_2"   # GP Serverless 2 vCores
sql_max_size_gb        = 32
sql_auto_pause_delay   = 60              # minutes of inactivity before auto-pause

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
- [ ] **Grant Managed Identity access to SQL Database** — Connect to the database and run `CREATE USER [mi-name] FROM EXTERNAL PROVIDER; ALTER ROLE db_datareader ADD MEMBER [mi-name]; ALTER ROLE db_datawriter ADD MEMBER [mi-name];`
- [ ] **Configure container app revision** — Update image tag in `terraform.tfvars` and re-apply, or use `az containerapp update`
- [ ] **Verify database connectivity** — Check container logs for successful SQL Database connection
- [ ] **Set up CI/CD pipeline** — Configure GitHub Actions or Azure DevOps for automated image builds and deployments
- [ ] **Configure custom domain** — If needed, add custom domain and TLS certificate to Container App ingress

## Important Notes

- **NEVER use `azurerm_mssql_firewall_rule` with 0.0.0.0/0** — The "Allow Azure Services" rule is a security anti-pattern. Use Private Endpoints exclusively in standard/premium tiers.
- **Serverless auto-pause** — SQL Database Serverless auto-pauses after the configured inactivity period (default 60 min). The first connection after pause takes ~1 minute (cold start). Only available on General Purpose tier.
- **TDE enabled by default** — Transparent Data Encryption is active on all Azure SQL Databases. You get encryption at rest with zero configuration.
- **Failover groups (premium)** — Require a secondary SQL Server in another region. Provides automatic failover with read replicas for HA/DR.
- **Managed Identity auth** — Requires running `CREATE USER [identity-name] FROM EXTERNAL PROVIDER` post-deployment. This SQL command cannot be executed via Terraform.
- **Connection pooling** — ADO.NET (SqlClient) handles connection pooling natively. For Java/Node.js applications, configure the pool at the application level.
- **Subnet sizing** — Container Apps Environment subnet cannot be resized after creation. Plan your IP address space carefully (/23 recommended minimum for production).
- **Application Insights** — Container Apps does NOT have auto-instrumentation for Application Insights. You must include the OpenTelemetry SDK in your container image to collect traces and metrics.
- Always run `terraform plan` before `terraform apply` — verify zero unintended changes.

## Cost Estimates

| Tier | Estimated Monthly Cost |
|------|------------------------|
| Basic | ~20 EUR/month (Consumption plan + SQL Database Basic 5 DTU) |
| Standard | ~200 EUR/month (Workload profiles + SQL Database GP S-series 2 vCores serverless) |
| Premium | ~700 EUR/month (Zone redundant + SQL Database BC 4 vCores + failover group) |

*Costs depend on container replicas, CPU/memory allocation, database DTU/vCore usage, and storage. Consumption plan billing is per-request; Workload Profiles are per-vCPU-second. Serverless SQL billing is per-vCore-second when active.*

## Validation Status

> **This stack is in development. It has NOT been tested on a live Azure environment yet.**

| Phase | Status |
|-------|--------|
| Terraform validate/plan | Pending |
| Terraform apply (lab) | Pending |
| Container App deployment verified | Pending |
| SQL Database connectivity tested | Pending |
| Managed Identity auth verified | Pending |
| Multi-tier tested (basic/standard/premium) | Pending |
| Cost estimates verified | Pending |
| Checkov 0 failed | Pending |

This stack will NOT be integrated into the AethronOps engine or made available for purchase until all phases are validated.

## Disclaimer

AethronOps templates are aligned with Microsoft best practices and compliance frameworks. They do not constitute a compliance certification. Users are responsible for validating their deployments against their own regulatory requirements. Always run `terraform plan` before applying any changes to production environments.

---

**[View all stacks](https://aethronops.com/stacks) · [Generate this stack](https://aethronops.com/stacks/container-app-sql)**
