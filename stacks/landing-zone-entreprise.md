# Landing Zone Enterprise

Hub-spoke network, Firewall, Bastion, DNS Private Resolver, Policy, and centralized monitoring. CAF-aligned.

## Azure Resources Deployed

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

## Tiers

- **Basic** (11 resources) — Dev/POC — core services, public access.
- **Standard** (18 resources) — Production — adds VNet isolation, NSG, Private Endpoints.
- **Premium** (24 resources) — Enterprise — adds Private Endpoints, Firewall, Bastion, Front Door, Backup Vault.

## What You Get

A Terraform project (ZIP) ready to `terraform init && apply`:

- Multi-file structure (networking.tf, identity.tf, monitoring.tf, etc.)
- Built on [Azure Verified Modules (AVM)](https://azure.github.io/Azure-Verified-Modules/) — Microsoft's official Terraform modules
- Pre-configured `terraform.tfvars` for your chosen tier
- Managed Identity on every resource (no credentials in code)
- Diagnostic settings to Log Analytics on every resource
- Key Vault for secrets management
- Checkov security scan: 0 failed checks
- README with deployment instructions

---

**[View all stacks](https://aethronops.com/stacks) · [Get this stack](https://aethronops.com/stacks/landing-zone-entreprise)**
