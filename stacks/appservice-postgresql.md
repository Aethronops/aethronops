# App Service + PostgreSQL

Azure App Service with PostgreSQL Flexible Server, Key Vault, Storage, and monitoring.

## Azure Resources Deployed

- Resource Group
- Log Analytics Workspace
- Managed Identity (User-Assigned)
- Key Vault
- Virtual Network + Subnets
- NAT Gateway
- Network Security Group (NSG)
- Storage Account
- App Service Plan
- App Service (Linux)
- PostgreSQL Flexible Server
- Application Insights
- Backup Vault
- Private DNS Zone
- Private Endpoint

## Tiers

- **Basic** — Dev/POC — core services, public access.
- **Standard** — Production — adds VNet isolation, NSG.
- **Premium** (68 resources) — Enterprise — adds Private Endpoints, Backup Vault.

## What You Get

A Terraform project (ZIP) ready to `terraform init && apply`.

### Why this is hard to do yourself

[Azure Verified Modules (AVM)](https://azure.github.io/Azure-Verified-Modules/) are Microsoft's official Terraform modules — but wiring them together is the hard part. Each module has its own interface, naming conventions, version constraints, and dependency chain. Getting them to work together with proper network isolation, identity, monitoring, and secrets management takes days of work for an experienced engineer.

We did that work. Every stack is:

- **Wired and tested** — all module dependencies resolved, `terraform plan` verified, Checkov scan passed with 0 failed checks
- **Multi-file structure** — networking.tf, identity.tf, monitoring.tf, keyvault.tf, etc. (not a single 2000-line main.tf)
- **Managed Identity everywhere** — no credentials in code, no service principal secrets to rotate
- **Diagnostic settings on every resource** — logs flowing to Log Analytics from day one
- **Key Vault for secrets** — TLS certificates, connection strings, passwords — nothing in plaintext
- **Pre-configured `terraform.tfvars`** — pick your tier, set your project name, deploy

### Security posture included

Each stack ships with a SECURITY-POSTURE.md that maps every deployed resource to 9 security frameworks: CAF, WAF, MCSB, GDPR, NIS2, DORA, PCI-DSS, HDS, and EU AI Act (where applicable). This is not a certificate — it's a transparent audit trail showing exactly what each resource does for your security posture.

---

**[View all stacks](https://aethronops.com/stacks) · [Get this stack](https://aethronops.com/stacks/appservice-postgresql)**
