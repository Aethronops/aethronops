# Serverless Full-Stack

Static Web App (frontend) + Function App (API) + Cosmos DB (database) + monitoring.

## Azure Resources Deployed

- Resource Group
- Log Analytics Workspace
- Managed Identity (User-Assigned)
- Key Vault
- Virtual Network + Subnets
- NAT Gateway
- Network Security Group (NSG)
- Static Web App
- App Service Plan
- Azure Functions
- Azure Cosmos DB
- Storage Account
- Application Insights
- Backup Vault
- Private DNS Zone
- Private Endpoint

## Tiers

- **Basic** — Dev/POC — core services, public access.
- **Standard** — Production — adds VNet isolation, NSG.
- **Premium** (62 resources) — Enterprise — adds Private Endpoints, Backup Vault.

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

**[View all stacks](https://aethronops.com/stacks) · [Get this stack](https://aethronops.com/stacks/serverless-fullstack)**
