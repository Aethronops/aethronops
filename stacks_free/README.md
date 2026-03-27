# Free Stacks

5 complete Terraform stacks you can use right now. Each one comes in 3 tiers (basic / standard / premium).

This is the exact same code we generate for paid stacks — same AVM modules, same structure, same security posture.

## Stacks

| Stack | What it deploys |
|-------|----------------|
| [storage-baseline](storage-baseline/) | Storage Account, Key Vault, Managed Identity, Log Analytics |
| [governance-subscription](governance-subscription/) | Budgets, Defender plans, RBAC, diagnostic settings |
| [governance-organization](governance-organization/) | Management Groups, Policy definitions, Policy assignments |
| [platform-management](platform-management/) | Log Analytics, App Insights, Key Vault, Automation Account |
| [static-web-app](static-web-app/) | Static Web App, Key Vault, Storage, Managed Identity, Log Analytics |

## How to use

```bash
cd stacks_free/storage-baseline/basic
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

Pick the tier that matches your needs:
- **basic** — minimal, public access, good for dev/POC
- **standard** — adds VNet isolation, NSG
- **premium** — adds Private Endpoints, Backup Vault

## What's inside each tier

```
main.tf                 # Providers, locals, naming
resource_group.tf       # Resource Group
variables.tf            # All input variables
outputs.tf              # Stack outputs
terraform.tfvars        # Pre-configured for the tier
backend.tf.example      # Remote state template
.checkov.yaml           # Security scan config
README.md               # Deployment instructions
SECURITY-POSTURE.md     # Security framework mappings
manifest.yaml           # Stack metadata
+ domain-specific files (networking.tf, identity.tf, monitoring.tf, etc.)
```

---

**[See all 78 stacks on aethronops.com](https://aethronops.com/stacks)**
