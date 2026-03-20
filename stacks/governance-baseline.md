# Governance Baseline

Azure governance foundation with Policy assignments, budgets, and monitoring. The starting point for subscription-level governance.

**Compliance:** CAF · WAF · MCSB · RGPD · NIS2

## Azure Components

- Resource Group
- Log Analytics Workspace
- Managed Identity (User-Assigned)
- Key Vault
- Storage Account
- Application Insights
- Automation Account
- App Configuration Store
- Virtual Network + Subnets
- NAT Gateway
- Network Security Group (NSG)
- Backup Vault
- Private DNS Zone (kv)
- Private Endpoint (kv)
- Private DNS Zone (storage)
- Private Endpoint (storage)

## Available Tiers

- **Basic** (8 resources) — Core services, public access. Suitable for development and proof-of-concept.
- **Standard** (11 resources) — Adds VNet isolation, NSG, and production-grade configuration.
- **Premium** (15 resources) — Full network isolation with Private Endpoints, Backup Vault, and enterprise hardening.

## What You Get

A complete Terraform project (ZIP) with:

- Multi-file structure (networking.tf, identity.tf, monitoring.tf, etc.)
- Azure Verified Modules (AVM) — Microsoft's official Terraform modules
- Pre-configured `terraform.tfvars` for your chosen tier
- Compliance report (COMPLIANCE.md) with control mappings
- Checkov security scanning configuration
- README with architecture overview and deployment instructions

---

**[View all stacks](https://aethronops.com/stacks) · [Generate this stack](https://aethronops.com/stacks/governance-baseline)**
