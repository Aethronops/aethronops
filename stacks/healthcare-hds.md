# Healthcare HDS

App Service + PostgreSQL + Firewall + Bastion with extended audit logging. Built for healthcare data hosting (HDS).

## Azure Resources Deployed

- Resource Group
- Log Analytics Workspace
- Managed Identity (User-Assigned)
- Key Vault
- Virtual Network + Subnets
- Network Security Group (NSG)
- Azure Firewall
- Route Table (UDR)
- Azure Bastion
- Storage Account
- App Service Plan
- App Service (Linux)
- Application Insights
- PostgreSQL Flexible Server
- Azure Front Door
- Backup Vault
- Private DNS Zone
- Private Endpoint

## Tiers

- **Basic** (12 resources) — Dev/POC — core services, public access.
- **Standard** (11 resources) — Production — adds VNet isolation, NSG.
- **Premium** (69 resources) — Enterprise — adds Private Endpoints, Firewall, Bastion, Front Door, Backup Vault.

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

**[View all stacks](https://aethronops.com/stacks) · [Get this stack](https://aethronops.com/stacks/healthcare-hds)**
