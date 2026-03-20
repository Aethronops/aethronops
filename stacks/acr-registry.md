# Azure Container Registry

Private container registry with geo-replication, vulnerability scanning, and network isolation. Store and manage Docker images for AKS, App Service, and Container Apps.

**Compliance:** CAF · WAF · MCSB · RGPD · NIS2

## Azure Components

- Resource Group
- Log Analytics Workspace
- Virtual Network + Subnets
- NAT Gateway
- Network Security Group (NSG)
- Managed Identity (User-Assigned)
- Key Vault
- Azure Container Registry (ACR)
- Application Insights
- Azure Bastion
- Backup Vault
- Private DNS Zone
- Private Endpoint

## Available Tiers

- **Basic** (5 resources) — Core services, public access. Suitable for development and proof-of-concept.
- **Standard** (10 resources) — Adds VNet isolation, NSG, and production-grade configuration.
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

**[View all stacks](https://aethronops.com/stacks) · [Generate this stack](https://aethronops.com/stacks/acr-registry)**
