# DB Admin — Cosmos DB

Monitoring pack for an existing Cosmos DB account. Adds Log Analytics, diagnostic settings, alerts, and backup configuration.

## Azure Resources Deployed

- Resource Group
- Log Analytics Workspace
- Managed Identity (User-Assigned)
- Key Vault
- Virtual Network + Subnets
- NAT Gateway
- Network Security Group (NSG)
- Azure Cosmos DB
- Private DNS Zone
- Private Endpoint

## Tiers

- **Basic** (5 resources) — Dev/POC — core services, public access.
- **Standard** (7 resources) — Production — adds VNet isolation, NSG.
- **Premium** (11 resources) — Enterprise — adds Private Endpoints.

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

**[View all stacks](https://aethronops.com/stacks) · [Get this stack](https://aethronops.com/stacks/db-admin-cosmosdb)**
