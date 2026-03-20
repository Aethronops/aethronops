# Governance Organization

Organization-wide governance with Management Groups, Policy initiatives, and centralized monitoring. For multi-subscription Azure estates.

**Compliance:** CAF · WAF · MCSB · RGPD · NIS2

## Azure Components

- Management Group
- Policy Definitions
- Policy Initiatives
- Policy Assignments
- Policy Exemptions
- Policy Remédiation
- Custom Rbac Definitions

## Available Tiers

- **Basic** (3 resources) — Core services, public access. Suitable for development and proof-of-concept.
- **Standard** (5 resources) — Adds VNet isolation, NSG, and production-grade configuration.
- **Premium** (7 resources) — Full network isolation with Private Endpoints, Backup Vault, and enterprise hardening.

## What You Get

A complete Terraform project (ZIP) with:

- Multi-file structure (networking.tf, identity.tf, monitoring.tf, etc.)
- Azure Verified Modules (AVM) — Microsoft's official Terraform modules
- Pre-configured `terraform.tfvars` for your chosen tier
- Compliance report (COMPLIANCE.md) with control mappings
- Checkov security scanning configuration
- README with architecture overview and deployment instructions

---

**[View all stacks](https://aethronops.com/stacks) · [Generate this stack](https://aethronops.com/stacks/governance-organization)**
