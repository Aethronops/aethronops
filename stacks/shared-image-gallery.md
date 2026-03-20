# Shared Image Gallery

Azure Compute Gallery for managing and distributing custom VM images. Version control, replication, and RBAC for golden images.

**Compliance:** CAF · WAF · MCSB · RGPD · NIS2

## Azure Components

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

## Available Tiers

- **Basic** (5 resources) — Core services, public access. Suitable for development and proof-of-concept.
- **Standard** (8 resources) — Adds VNet isolation, NSG, and production-grade configuration.
- **Premium** (12 resources) — Full network isolation with Private Endpoints, Backup Vault, and enterprise hardening.

## What You Get

A complete Terraform project (ZIP) with:

- Multi-file structure (networking.tf, identity.tf, monitoring.tf, etc.)
- Azure Verified Modules (AVM) — Microsoft's official Terraform modules
- Pre-configured `terraform.tfvars` for your chosen tier
- Compliance report (COMPLIANCE.md) with control mappings
- Checkov security scanning configuration
- README with architecture overview and deployment instructions

---

**[View all stacks](https://aethronops.com/stacks) · [Generate this stack](https://aethronops.com/stacks/shared-image-gallery)**
