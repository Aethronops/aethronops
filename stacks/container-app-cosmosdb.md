# Container Apps + Cosmos DB

Azure Container Apps with Cosmos DB (NoSQL API), Key Vault, Managed Identity, and private networking. Ideal for globally distributed microservices with sub-10ms latency and automatic scaling.

**Compliance:** CAF · WAF · MCSB · RGPD · NIS2

## Azure Components

- Resource Group
- Container Apps Environment (Workload Profiles)
- Container App
- Cosmos DB Account (NoSQL API)
- Cosmos DB Database + Container
- Managed Identity (User-Assigned)
- Key Vault
- Log Analytics Workspace
- Application Insights
- Storage Account
- Virtual Network + Subnets (CAE, PE, mgmt)
- Network Security Group (NSG)
- Private Endpoint (Cosmos DB, Key Vault)
- Private DNS Zone (privatelink.documents.azure.com)

## Available Tiers

- **Basic** (~7 resources) — Container Apps (Consumption) + Cosmos DB Serverless + Key Vault + Managed Identity + Log Analytics + Storage. Public access, no VNet. Scale-to-zero for near-zero cost in dev/staging.
- **Standard** (~14 resources) — Adds Workload Profiles, Cosmos DB Provisioned throughput (400-1000 RU/s), VNet isolation, Private Endpoints, NSG, RBAC data plane with `disableLocalAuth`. For production workloads.
- **Premium** (~20 resources) — Zone-redundant CAE, Cosmos DB Autoscale (1000-4000 RU/s), multi-region writes, Continuous Backup (PITR), advanced monitoring, full network isolation. For enterprise and NIS2/DORA compliance.

## What You Get

A complete Terraform project (ZIP) with:

- Multi-file structure (networking.tf, identity.tf, monitoring.tf, database.tf, container.tf, etc.)
- Azure Verified Modules (AVM) — Microsoft's official Terraform modules
- Pre-configured `terraform.tfvars` for your chosen tier
- Cosmos DB NoSQL API with partition key configuration
- Managed Identity RBAC authentication (Cosmos DB Built-in Data Contributor role — no connection string needed)
- OpenTelemetry-ready monitoring configuration
- Compliance report (COMPLIANCE.md) with MCSB, RGPD Art. 32, and NIS2 Art. 21(2) mappings
- Checkov security scanning configuration
- README with deployment guide

## Prerequisites

Before deploying, ensure your environment meets these requirements:

### Azure Subscription
- Resource providers registered:
  - `Microsoft.App`
  - `Microsoft.DocumentDB`
- Service Principal or Managed Identity with `Contributor` role on the target Resource Group

### Container Image
- A container image available in a registry (or a public image for initial testing in basic tier)
- Application must use a Cosmos DB SDK that supports Managed Identity authentication (Azure Identity + CosmosClient)

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

# Cosmos DB
cosmosdb_consistency_level  = "Session"          # Session = best default
cosmosdb_partition_key_path = "/partitionKey"     # CRITICAL — cannot change later
cosmosdb_throughput_mode    = "serverless"        # serverless | provisioned | autoscale
cosmosdb_max_throughput     = 4000                # autoscale max RU/s (premium)

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

- [ ] **Push container image** — Push your application image to a registry accessible by Container Apps
- [ ] **Configure container app revision** — Update image tag in `terraform.tfvars` and re-apply, or use `az containerapp update`
- [ ] **Verify Cosmos DB connectivity** — Check container logs for successful Cosmos DB SDK connection via Managed Identity
- [ ] **Test partition key strategy** — Validate your partition key choice with realistic data volumes
- [ ] **Set up CI/CD pipeline** — Configure GitHub Actions or Azure DevOps for automated image builds and deployments
- [ ] **Configure custom domain** — If needed, add custom domain and TLS certificate to Container App ingress

## Important Notes

- **Partition key is immutable** — The partition key path is set at container creation and CANNOT be changed afterward. Choose carefully based on your query patterns and data distribution.
- **Cosmos DB Serverless burst limit** — Serverless mode has a 1000 RU/s burst limit. It is NOT suitable for sustained high throughput. Use Provisioned or Autoscale for production.
- **RU consumption varies** — Request Unit cost depends heavily on query complexity, document size, and indexing. Always test with realistic data before choosing throughput.
- **Consistency levels** — Session consistency is the default and best for most cases. Strong consistency doubles RU cost and increases latency. Only use Strong if your application strictly requires it.
- **Managed Identity RBAC** — Connection via Managed Identity uses the Cosmos DB Built-in Data Contributor role. No connection string or key is needed. For security, `disableLocalAuth = true` is enforced in standard/premium.
- **No NAT Gateway needed** — Unlike SQL-based stacks, Cosmos DB does not require fixed outbound IP. NAT Gateway is not included.
- **Application Insights** — Container Apps does NOT have auto-instrumentation for Application Insights. You must include the OpenTelemetry SDK in your container image to collect traces and metrics.
- Always run `terraform plan` before `terraform apply` — verify zero unintended changes.

## Cost Estimates

| Tier | Estimated Monthly Cost |
|------|------------------------|
| Basic | ~5-25 EUR/month (Consumption plan + Cosmos DB Serverless, pay per RU) |
| Standard | ~150-400 EUR/month (Workload Profiles + Cosmos DB 400-1000 RU/s provisioned) |
| Premium | ~500-2000 EUR/month (Zone redundant + Cosmos DB Autoscale 1000-4000 RU/s + multi-region) |

*Costs depend on container replicas, CPU/memory allocation, RU/s consumption, and storage. Consumption plan billing is per-request; Workload Profiles are per-vCPU-second. Cosmos DB Serverless is billed per RU consumed; Provisioned/Autoscale is billed per RU/s provisioned.*

## Validation Status

> **This stack is in development. It has NOT been tested on a live Azure environment yet.**

| Phase | Status |
|-------|--------|
| Terraform validate/plan | Pending |
| Terraform apply (lab) | Pending |
| Container App deployment verified | Pending |
| Cosmos DB connectivity tested | Pending |
| Managed Identity RBAC verified | Pending |
| Multi-tier tested (basic/standard/premium) | Pending |
| Cost estimates verified | Pending |
| Checkov 0 failed | Pending |

This stack will NOT be integrated into the AethronOps engine or made available for purchase until all phases are validated.

## Disclaimer

AethronOps templates are aligned with Microsoft best practices and compliance frameworks. They do not constitute a compliance certification. Users are responsible for validating their deployments against their own regulatory requirements. Always run `terraform plan` before applying any changes to production environments.

---

**[View all stacks](https://aethronops.com/stacks) · [Generate this stack](https://aethronops.com/stacks/container-app-cosmosdb)**
