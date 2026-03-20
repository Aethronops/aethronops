# Hub-Spoke Network

Classic hub-spoke network topology. Central hub VNet with Bastion for admin access, optional Azure Firewall for traffic filtering. Spokes connect via VNet peering.

**Compliance:** CAF · WAF · MCSB · RGPD · NIS2

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
- Backup Vault
- Private DNS Zone
- Private Endpoint

## Available Tiers

- **Basic** (6 resources) — Core services, public access. Suitable for development and proof-of-concept.
- **Standard** (7 resources) — Adds VNet isolation, NSG, and production-grade configuration.
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

**[View all stacks](https://aethronops.com/stacks) · [Generate this stack](https://aethronops.com/stacks/hub-spoke-network)**
