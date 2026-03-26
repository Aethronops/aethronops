# Platform Management

Log Analytics, Automation Account, and centralized monitoring. CAF management subscription for Landing Zone architectures.

## Azure Resources Deployed

- Resource Group
- Log Analytics Workspace
- Managed Identity (User-Assigned)
- Key Vault
- Storage Account
- Application Insights
- Automation Account
- Backup Vault

## Tiers

- **Basic** (6 resources) — Dev/POC — core services, public access.
- **Standard** (8 resources) — Production configuration.
- **Premium** (26 resources) — Enterprise — adds Backup Vault.

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

**[View all stacks](https://aethronops.com/stacks) · [Get this stack](https://aethronops.com/stacks/platform-management)**
