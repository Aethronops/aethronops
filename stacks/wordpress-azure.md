# WordPress on Azure

WordPress on App Service with MySQL Flexible Server, Front Door CDN, Key Vault, Storage, and monitoring. Production-grade WordPress without managing servers.

**Compliance:** CAF · WAF · MCSB · RGPD · NIS2

## Azure Components

- Resource Group
- Log Analytics Workspace
- Managed Identity (User-Assigned)
- Key Vault
- Virtual Network + Subnets
- NAT Gateway
- Network Security Group (NSG)
- Route Table (UDR)
- Storage Account
- App Service Plan
- App Service (Linux)
- MySQL Flexible Server
- Application Insights
- Azure Bastion
- Backup Vault
- Private DNS Zone
- Private Endpoint

## Available Tiers

- **Basic** (7 resources) — Core services, public access. Suitable for development and proof-of-concept.
- **Standard** (11 resources) — Adds VNet isolation, NSG, and production-grade configuration.
- **Premium** (16 resources) — Full network isolation with Private Endpoints, Backup Vault, and enterprise hardening.

## What You Get

A complete Terraform project (ZIP) with:

- Multi-file structure (networking.tf, identity.tf, monitoring.tf, etc.)
- Azure Verified Modules (AVM) — Microsoft's official Terraform modules
- Pre-configured `terraform.tfvars` for your chosen tier
- Compliance report (COMPLIANCE.md) with control mappings
- Checkov security scanning configuration
- README with architecture overview and deployment instructions

---

**[View all stacks](https://aethronops.com/stacks) · [Generate this stack](https://aethronops.com/stacks/wordpress-azure)**
