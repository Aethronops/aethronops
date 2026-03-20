# Container Apps + MySQL

Azure Container Apps with MySQL Flexible Server, Key Vault, Managed Identity, and private networking. Production-ready microservices platform with managed MySQL database.

**Compliance:** CAF · WAF · MCSB · RGPD · NIS2

## Azure Components

- Resource Group
- Container Apps Environment (Workload Profiles)
- Container App
- MySQL Flexible Server
- Managed Identity (User-Assigned)
- Key Vault
- Log Analytics Workspace
- Application Insights
- Storage Account
- Virtual Network + Subnets (CAE, DB, PE, mgmt)
- NAT Gateway
- Network Security Group (NSG)
- Private Endpoint (MySQL, Key Vault, ACR)
- Private DNS Zone
- Azure Container Registry
- Backup Vault

## Available Tiers

- **Basic** (~8 resources) — Container Apps (Consumption) + MySQL B1ms + Key Vault + Managed Identity + Log Analytics + Storage. Public access, no VNet, no connection pooling. For dev/POC.
- **Standard** (~15 resources) — Adds Workload Profiles, MySQL GP D2ds_v4, VNet isolation, NAT Gateway, Private Endpoints, NSG, ACR with PE. Application-level connection pooling recommended (ProxySQL sidecar or SDK pooling). For production workloads.
- **Premium** (~22 resources) — Zone-redundant MySQL HA (Business Critical D4ds_v4 with thread_pool), Backup Vault, advanced monitoring, full network isolation. For enterprise and NIS2/DORA compliance.

## What You Get

A complete Terraform project (ZIP) with:

- Multi-file structure (networking.tf, identity.tf, monitoring.tf, database.tf, container.tf, etc.)
- Azure Verified Modules (AVM) — Microsoft's official Terraform modules
- Pre-configured `terraform.tfvars` for your chosen tier
- Managed Identity authentication to MySQL (`azure_identity` plugin + `aad_auth_only = ON`)
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
  - `Microsoft.DBforMySQL`
  - `Microsoft.ContainerRegistry`
- Service Principal or Managed Identity with `Contributor` role on the target Resource Group

### Container Image
- A container image available in ACR (or a public image for initial testing)
- MySQL Flexible Server **General Purpose** tier or higher is required for High Availability and Private Endpoints

### MySQL Version
- MySQL 8.0 recommended (5.7 is deprecated)

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

# MySQL
mysql_sku_name       = "GP_Standard_D2ds_v4"   # GP required for HA and PE
mysql_storage_gb     = 32
mysql_version        = "8.0.21"

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
- [ ] **Verify database connectivity** — Check container logs for successful MySQL connection
- [ ] **Set up CI/CD pipeline** — Configure GitHub Actions or Azure DevOps for automated image builds and deployments
- [ ] **Configure custom domain** — If needed, add custom domain and TLS certificate to Container App ingress

## Important Notes

- **Connection pooling** — MySQL Flexible Server does NOT have a built-in connection pooler like PostgreSQL's PgBouncer. The `thread_pool` plugin is ONLY available on Business Critical tier. For General Purpose tier, use ProxySQL as a sidecar container or application-level connection pooling (HikariCP for Java, mysql2 pool for Node.js, SQLAlchemy pool for Python).
- **Managed Identity authentication** — MySQL Managed Identity auth requires the `azure_identity` plugin and `aad_auth_only = ON`, which disables local password authentication entirely. Ensure your application SDK supports Azure AD token-based MySQL authentication.
- **No extensions** — Unlike PostgreSQL, MySQL does not support the `azure.extensions` server parameter. Authentication plugin configuration is handled via server parameters.
- **Subnet sizing** — Container Apps Environment subnet cannot be resized after creation. Plan your IP address space carefully (/23 recommended minimum for production).
- **Application Insights** — Container Apps does NOT have auto-instrumentation for Application Insights. You must include the OpenTelemetry SDK in your container image to collect traces and metrics.
- **MySQL 5.7 deprecation** — MySQL 5.7 is deprecated on Azure. Always use MySQL 8.0 for new deployments.
- **Private DNS zone** — MySQL Flexible Server uses `privatelink.mysql.database.azure.com` for private endpoint DNS resolution.
- Always run `terraform plan` before `terraform apply` — verify zero unintended changes.

## Cost Estimates

| Tier | Estimated Monthly Cost |
|------|------------------------|
| Basic | ~15 EUR/month (Consumption plan + MySQL B1ms) |
| Standard | ~180 EUR/month (Workload profiles + MySQL GP D2ds_v4) |
| Premium | ~550 EUR/month (Zone redundant + MySQL BC D4ds_v4 HA + Backup) |

*Costs depend on container replicas, CPU/memory allocation, and database storage. Consumption plan billing is per-request; Workload Profiles are per-vCPU-second. MySQL HA doubles the compute cost (standby replica).*

## Validation Status

> **This stack is in development. It has NOT been tested on a live Azure environment yet.**

| Phase | Status |
|-------|--------|
| Terraform validate/plan | Pending |
| Terraform apply (lab) | Pending |
| Container App deployment verified | Pending |
| MySQL connectivity tested | Pending |
| Managed Identity auth verified | Pending |
| Multi-tier tested (basic/standard/premium) | Pending |
| Cost estimates verified | Pending |
| Checkov 0 failed | Pending |

This stack will NOT be integrated into the AethronOps engine or made available for purchase until all phases are validated.

## Disclaimer

AethronOps templates are aligned with Microsoft best practices and compliance frameworks. They do not constitute a compliance certification. Users are responsible for validating their deployments against their own regulatory requirements. Always run `terraform plan` before applying any changes to production environments.

---

**[View all stacks](https://aethronops.com/stacks) · [Generate this stack](https://aethronops.com/stacks/container-app-mysql)**
