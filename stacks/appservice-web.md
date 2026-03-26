# App Service Web

Azure App Service for web applications with Key Vault, Storage, and monitoring. Optionally add PostgreSQL, MySQL, or Azure SQL during generation.

## Azure Resources Deployed

- Resource Group
- Log Analytics Workspace
- Virtual Network + Subnets
- NAT Gateway
- Network Security Group (NSG)
- Managed Identity (User-Assigned)
- Key Vault
- Storage Account
- App Service Plan
- App Service (Linux)
- Application Insights
- PostgreSQL Flexible Server
- MySQL Flexible Server
- Azure SQL Database
- Azure Front Door
- Private Endpoint
- Private DNS Zone
- Backup Vault

## Tiers

- **Basic** (7 resources) — Dev/POC — core services, public access.
- **Standard** (13 resources) — Production — adds VNet isolation, NSG, Private Endpoints.
- **Premium** (54 resources) — Enterprise — adds Private Endpoints, Front Door, Backup Vault.

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

**[View all stacks](https://aethronops.com/stacks) · [Get this stack](https://aethronops.com/stacks/appservice-web)**
