# Container Apps Baseline

Azure Container Apps with Container Apps Environment, ACR, Key Vault, and monitoring. Serverless containers without managing Kubernetes.

**Compliance:** CAF · WAF · MCSB · RGPD · NIS2

## Azure Components

- Resource Group
- Log Analytics Workspace
- Managed Identity (User-Assigned)
- Key Vault
- Container Apps Environment
- Azure Container Apps
- Virtual Network + Subnets
- NAT Gateway
- Network Security Group (NSG)
- Storage Account
- Private DNS Zone
- Private Endpoint
- Backup Vault

## Available Tiers

- **Basic** (6 resources) — Core services, public access. Suitable for development and proof-of-concept.
- **Standard** (9 resources) — Adds VNet isolation, NSG, and production-grade configuration.
- **Premium** (13 resources) — Full network isolation with Private Endpoints, Backup Vault, and enterprise hardening.

## What You Get

A complete Terraform project (ZIP) with:

- Multi-file structure (networking.tf, identity.tf, monitoring.tf, etc.)
- Azure Verified Modules (AVM) — Microsoft's official Terraform modules
- Pre-configured `terraform.tfvars` for your chosen tier
- Compliance report (COMPLIANCE.md) with control mappings
- Checkov security scanning configuration
- README with architecture overview and deployment instructions

---

**[View all stacks](https://aethronops.com/stacks) · [Generate this stack](https://aethronops.com/stacks/container-apps-baseline)**
