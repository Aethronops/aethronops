# Platform Connectivity

Hub VNet, Firewall, Bastion, DNS Private Resolver, Private DNS Zones, and DDoS Protection. CAF hub for Landing Zone architectures.

## Azure Resources Deployed

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

## Tiers

- **Basic** (10 resources) — Dev/POC — core services, public access.
- **Standard** (18 resources) — Production — adds VNet isolation, NSG, Private Endpoints.
- **Premium** (80 resources) — Enterprise — adds Private Endpoints, Firewall, Bastion, Backup Vault.

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

**[View all stacks](https://aethronops.com/stacks) · [Get this stack](https://aethronops.com/stacks/platform-connectivity)**
