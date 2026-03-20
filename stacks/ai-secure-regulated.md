# AI Secure Regulated

Fully isolated AI platform for regulated industries. Azure OpenAI + AI Search + Machine Learning behind Azure Firewall, Bastion, and Private Endpoints. Aligned with NIS2 and DORA.

**Compliance:** CAF · WAF · MCSB · RGPD · NIS2

## Azure Components

- Resource Group
- Log Analytics Workspace
- Managed Identity (User-Assigned)
- Key Vault
- Virtual Network + Subnets
- NAT Gateway
- Network Security Group (NSG)
- Azure OpenAI (Cognitive Services)
- Search Searchservice
- Api Management
- Application Insights
- Storage Account
- Backup Vault
- Private DNS Zone
- Private Endpoint

## Available Tiers

- **Basic** (10 resources) — Core services, public access. Suitable for development and proof-of-concept.
- **Standard** (12 resources) — Adds VNet isolation, NSG, and production-grade configuration.
- **Premium** (22 resources) — Full network isolation with Private Endpoints, Backup Vault, and enterprise hardening.

## What You Get

A complete Terraform project (ZIP) with:

- Multi-file structure (networking.tf, identity.tf, monitoring.tf, etc.)
- Azure Verified Modules (AVM) — Microsoft's official Terraform modules
- Pre-configured `terraform.tfvars` for your chosen tier
- Compliance report (COMPLIANCE.md) with control mappings
- Checkov security scanning configuration
- README with architecture overview and deployment instructions

---

**[View all stacks](https://aethronops.com/stacks) · [Generate this stack](https://aethronops.com/stacks/ai-secure-regulated)**
