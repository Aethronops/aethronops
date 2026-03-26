# Governance Organization

Management Groups, Policy initiatives, and centralized monitoring for multi-subscription Azure estates.

## Azure Resources Deployed

- Management Group
- Policy Definitions
- Policy Initiatives
- Policy Assignments
- Policy Exemptions
- Policy Remédiation
- Custom Rbac Definitions

## Tiers

- **Basic** — Dev/POC — core services, public access.
- **Standard** — Production configuration.
- **Premium** (12 resources) — Enterprise hardening.

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

**[View all stacks](https://aethronops.com/stacks) · [Get this stack](https://aethronops.com/stacks/governance-organization)**
