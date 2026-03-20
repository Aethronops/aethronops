# Platform Connectivity

CAF Platform connectivity with hub VNet, Firewall, Bastion, DNS Private Resolver, Private DNS Zones, and DDoS Protection. The hub for Landing Zone architectures.

**Compliance:** CAF · WAF · MCSB · RGPD · NIS2 · DORA

## Azure Components

- Resource Group
- Log Analytics Workspace
- Managed Identity (User-Assigned)
- Key Vault
- Virtual Network + Subnets
- NAT Gateway
- Network Security Group (NSG)
- Azure Firewall
- Route Table (UDR)
- Azure Bastion
- Storage Account
- Backup Vault
- Automation Account
- Private DNS Zone
- Private Endpoint
- Public IP Address
- DNS Private Resolver

## Available Tiers

- **Basic** (10 resources) — Core services, public access. Suitable for development and proof-of-concept.
- **Standard** (18 resources) — Adds VNet isolation, NSG, and production-grade configuration.
- **Premium** (25 resources) — Full network isolation with Private Endpoints, Backup Vault, and enterprise hardening.

## What You Get

A complete Terraform project (ZIP) with:

- Multi-file structure (networking.tf, identity.tf, monitoring.tf, etc.)
- Azure Verified Modules (AVM) — Microsoft's official Terraform modules
- Pre-configured `terraform.tfvars` for your chosen tier
- Compliance report (COMPLIANCE.md) with control mappings
- Checkov security scanning configuration
- README with architecture overview and deployment instructions

---

**[View all stacks](https://aethronops.com/stacks) · [Generate this stack](https://aethronops.com/stacks/platform-connectivity)**
