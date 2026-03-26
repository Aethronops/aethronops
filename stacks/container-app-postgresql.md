# Container Apps + PostgreSQL

Azure Container Apps with PostgreSQL Flexible Server, PgBouncer connection pooling, Key Vault, and monitoring.

## Azure Resources Deployed

- Resource Group
- Log Analytics Workspace
- Managed Identity (User-Assigned)
- Key Vault
- Storage Account
- Container Apps Environment
- Azure Container Apps
- PostgreSQL Flexible Server
- Virtual Network + Subnets
- NAT Gateway
- Network Security Group (NSG)
- Application Insights
- Private DNS Zone
- Private Endpoint
- Backup Vault
- Azure Front Door

## Tiers

- **Basic** (8 resources) — Dev/POC — core services, public access.
- **Standard** (14 resources) — Production — adds VNet isolation, NSG, Private Endpoints.
- **Premium** (20 resources) — Enterprise — adds Private Endpoints, Front Door, Backup Vault.

## What You Get

A Terraform project (ZIP) ready to `terraform init && apply`:

- Multi-file structure (networking.tf, identity.tf, monitoring.tf, etc.)
- Built on [Azure Verified Modules (AVM)](https://azure.github.io/Azure-Verified-Modules/) — Microsoft's official Terraform modules
- Pre-configured `terraform.tfvars` for your chosen tier
- Managed Identity on every resource (no credentials in code)
- Diagnostic settings to Log Analytics on every resource
- Key Vault for secrets management
- Checkov security scan: 0 failed checks
- README with deployment instructions

---

**[View all stacks](https://aethronops.com/stacks) · [Get this stack](https://aethronops.com/stacks/container-app-postgresql)**
