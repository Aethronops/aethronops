# PostgreSQL Private

Standalone PostgreSQL Flexible Server with full network isolation, Key Vault, monitoring, and backup. For workloads that need a dedicated private PostgreSQL instance.

**Compliance:** CAF · WAF · MCSB · RGPD · NIS2

## Azure Components

- Resource Group
- Log Analytics Workspace
- Virtual Network + Subnets
- NAT Gateway
- Network Security Group (NSG)
- Managed Identity (User-Assigned)
- Key Vault
- PostgreSQL Flexible Server
- Private DNS Zone
- Private Endpoint
- Backup Vault

## Available Tiers

- **Basic** (7 resources) — Core services, public access. Suitable for development and proof-of-concept.
- **Standard** (7 resources) — Adds VNet isolation, NSG, and production-grade configuration.
- **Premium** (11 resources) — Full network isolation with Private Endpoints, Backup Vault, and enterprise hardening.

## What You Get

A complete Terraform project (ZIP) with:

- Multi-file structure (networking.tf, identity.tf, monitoring.tf, etc.)
- Azure Verified Modules (AVM) — Microsoft's official Terraform modules
- Pre-configured `terraform.tfvars` for your chosen tier
- Compliance report (COMPLIANCE.md) with control mappings
- Checkov security scanning configuration
- README with architecture overview and deployment instructions

---

**[View all stacks](https://aethronops.com/stacks) · [Generate this stack](https://aethronops.com/stacks/postgresql-private)**
