# Dev Jump Box

Secure jump box VM with Bastion access, Managed Identity, and monitoring. For developers who need secure access to private Azure resources.

**Compliance:** CAF · WAF · MCSB · RGPD · NIS2

## Azure Components

- Resource Group
- Log Analytics Workspace
- Managed Identity (User-Assigned)
- Key Vault
- Virtual Network + Subnets
- NAT Gateway
- Network Security Group (NSG)
- Virtual Machine
- Storage Account
- Application Insights
- Route Table (UDR)
- Azure Bastion
- Backup Vault
- Private Endpoint
- Private DNS Zone

## Available Tiers

- **Basic** (7 resources) — Core services, public access. Suitable for development and proof-of-concept.
- **Standard** (9 resources) — Adds VNet isolation, NSG, and production-grade configuration.
- **Premium** (14 resources) — Full network isolation with Private Endpoints, Backup Vault, and enterprise hardening.

## What You Get

A complete Terraform project (ZIP) with:

- Multi-file structure (networking.tf, identity.tf, monitoring.tf, etc.)
- Azure Verified Modules (AVM) — Microsoft's official Terraform modules
- Pre-configured `terraform.tfvars` for your chosen tier
- Compliance report (COMPLIANCE.md) with control mappings
- Checkov security scanning configuration
- README with architecture overview and deployment instructions

---

**[View all stacks](https://aethronops.com/stacks) · [Generate this stack](https://aethronops.com/stacks/dev-jumpbox)**
