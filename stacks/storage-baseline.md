# Storage Baseline

Azure Storage Account with Key Vault and monitoring. Blob, File, Queue, and Table storage with encryption and lifecycle management.

## Azure Resources Deployed

- Resource Group
- Log Analytics Workspace
- Managed Identity (User-Assigned)
- Key Vault
- Storage Account
- Virtual Network + Subnets
- NAT Gateway
- Private DNS Zone
- Private Endpoint
- Backup Vault

## Tiers

- **Basic** (5 resources) — Dev/POC — core services, public access.
- **Standard** (6 resources) — Production — adds VNet isolation.
- **Premium** (36 resources) — Enterprise — adds Private Endpoints, Backup Vault.

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

**[View all stacks](https://aethronops.com/stacks) · [Get this stack](https://aethronops.com/stacks/storage-baseline)**
