# FinTech PCI-DSS Baseline

Hardened App Service + PostgreSQL with Azure Firewall, Bastion, Front Door WAF, and full network isolation. Aligned with PCI-DSS v4.0 and DORA (EU 2022/2554).

**Compliance:** CAF · WAF · MCSB · RGPD · NIS2 · DORA

## Azure Components

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

## Available Tiers

- **Basic** (12 resources) — Core services, public access. Suitable for development and proof-of-concept.
- **Standard** (11 resources) — Adds VNet isolation, NSG, and production-grade configuration.
- **Premium** (21 resources) — Full network isolation with Private Endpoints, Backup Vault, and enterprise hardening.

## What You Get

A complete Terraform project (ZIP) with:

- Multi-file structure (networking.tf, identity.tf, monitoring.tf, etc.)
- Azure Verified Modules (AVM) — Microsoft's official Terraform modules
- Pre-configured `terraform.tfvars` for your chosen tier
- Compliance report (COMPLIANCE.md) with control mappings
- Checkov security scanning configuration
- README with architecture overview and deployment instructions

---

**[View all stacks](https://aethronops.com/stacks) · [Generate this stack](https://aethronops.com/stacks/fintech-pci-baseline)**
