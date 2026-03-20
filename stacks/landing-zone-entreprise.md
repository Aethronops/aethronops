# Landing Zone Enterprise

CAF-aligned enterprise landing zone with hub-spoke network, Firewall, Bastion, DNS Private Resolver, Policy, and centralized monitoring.

**Compliance:** CAF · WAF · MCSB · RGPD · NIS2 · DORA

## Azure Components

- Resource Group
- Log Analytics Workspace
- Managed Identity (User-Assigned)
- Key Vault
- Storage Account
- Application Insights
- Virtual Network + Subnets
- Network Security Group (NSG)
- Azure Firewall
- Route Table (UDR)
- Azure Bastion
- Automation Account
- Backup Vault
- Recovery Services Vault
- Private DNS Zone
- Private Endpoint
- Azure Front Door
- WAF Policy (Front Door)
- DNS Private Resolver
- NAT Gateway
- Public IP Address
- DDoS Protection Plan

## Available Tiers

- **Basic** (11 resources) — Core services, public access. Suitable for development and proof-of-concept.
- **Standard** (18 resources) — Adds VNet isolation, NSG, and production-grade configuration.
- **Premium** (24 resources) — Full network isolation with Private Endpoints, Backup Vault, and enterprise hardening.

## What You Get

A complete Terraform project (ZIP) with:

- Multi-file structure (networking.tf, identity.tf, monitoring.tf, etc.)
- Azure Verified Modules (AVM) — Microsoft's official Terraform modules
- Pre-configured `terraform.tfvars` for your chosen tier
- Compliance report (COMPLIANCE.md) with control mappings
- Checkov security scanning configuration
- README with architecture overview and deployment instructions

---

**[View all stacks](https://aethronops.com/stacks) · [Generate this stack](https://aethronops.com/stacks/landing-zone-entreprise)**
