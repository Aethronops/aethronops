# Shared Image Gallery

Azure Compute Gallery for custom VM images. Version control, replication, and RBAC.

## Azure Resources Deployed

- Resource Group
- Log Analytics Workspace
- Managed Identity (User-Assigned)
- Key Vault
- Compute Gallery
- Virtual Network + Subnets
- NAT Gateway
- Network Security Group (NSG)
- Storage Account
- Route Table (UDR)
- Azure Bastion
- Private Endpoint
- Private DNS Zone

## Tiers

- **Basic** (5 resources) — Dev/POC — core services, public access.
- **Standard** (8 resources) — Production — adds VNet isolation, NSG.
- **Premium** (41 resources) — Enterprise — adds Private Endpoints, Bastion.

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

**[View all stacks](https://aethronops.com/stacks) · [Get this stack](https://aethronops.com/stacks/shared-image-gallery)**
