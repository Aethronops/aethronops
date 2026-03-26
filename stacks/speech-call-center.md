# Speech Call Center

AI Speech, Communication Services, Storage, and monitoring. Transcription, sentiment analysis, and call recording.

## Azure Resources Deployed

- Resource Group
- Log Analytics Workspace
- Managed Identity (User-Assigned)
- Key Vault
- Azure OpenAI (Cognitive Services)
- Storage Account
- Servicebus Namespace
- App Service Plan
- App Service (Linux)
- PostgreSQL Flexible Server
- Application Insights
- Virtual Network + Subnets
- NAT Gateway
- Network Security Group (NSG)
- Backup Vault
- Private DNS Zone
- Private Endpoint

## Tiers

- **Basic** (11 resources) — Dev/POC — core services, public access.
- **Standard** (13 resources) — Production — adds VNet isolation, NSG.
- **Premium** (91 resources) — Enterprise — adds Private Endpoints, Backup Vault.

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

**[View all stacks](https://aethronops.com/stacks) · [Get this stack](https://aethronops.com/stacks/speech-call-center)**
