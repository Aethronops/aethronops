# SaaS Multi-Tenant

App Service, Azure SQL, Front Door, Key Vault, and monitoring. Tenant isolation with shared infrastructure.

## Azure Resources Deployed

- Resource Group
- Log Analytics Workspace
- Managed Identity (User-Assigned)
- Key Vault
- Virtual Network + Subnets
- NAT Gateway
- Network Security Group (NSG)
- Storage Account
- App Service Plan
- App Service (Linux)
- Azure Cosmos DB
- Azure Cache for Redis
- Azure Front Door
- Application Insights
- Backup Vault
- Private DNS Zone
- Private Endpoint

## Tiers

- **Basic** (8 resources) — Dev/POC — core services, public access.
- **Standard** (11 resources) — Production — adds VNet isolation, NSG.
- **Premium** (66 resources) — Enterprise — adds Private Endpoints, Front Door, Backup Vault.

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

**[View all stacks](https://aethronops.com/stacks) · [Get this stack](https://aethronops.com/stacks/saas-multitenant)**
