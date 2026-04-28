# INSTALL — app-service-cosmosdb (dev)

Deploy this stack locally in ~10 minutes. No CI/CD required.

> Everything below is copy-pasteable. No portal clicks unless explicitly noted.

---

## 0. Prerequisites (everyone, dev or prod)

### 0.1 Tooling

| Tool | Minimum version | Install |
|---|---|---|
| Azure CLI | 2.61+ | `brew install azure-cli` or https://learn.microsoft.com/cli/azure/install-azure-cli |
| Terraform | 1.12.0+ | `brew install terraform` or https://developer.hashicorp.com/terraform/downloads |
| GitHub CLI | 2.40+ (prod only) | `brew install gh` or https://cli.github.com |
| jq (optional) | 1.6+ | `brew install jq` |

### 0.2 Azure sub + login

```bash
az login
az account set --subscription <your-subscription-id>
SUB=$(az account show --query id -o tsv)
TENANT=$(az account show --query tenantId -o tsv)
```

### 0.3 Permissions required on the subscription

Your user (or the service principal for CI/CD) must have:

- **Contributor** on the subscription (or target RG)
- **Role Based Access Control Administrator** on the subscription (to create role_assignments for Managed Identities)
- **Application Administrator** in Entra ID (to create SP + federated credentials — prod only)

### 0.4 Check quotas

```bash
az vm list-usage -l francecentral -o table | grep -E 'Standard|vCPU'
# Azure defaults are usually enough for this pack. If not, request quota increase:
# az support tickets create --ticket-name 'Quota increase' ...
```

---

## Deploy

Use this to deploy the pack locally on a sandbox or dev subscription.

### 1. Edit dev tfvars

```bash
cd app-service-cosmosdb
vim envs/dev.tfvars
# Set at minimum:
#   subscription_id = "<your sub>"
#   project_name    = "<max 8 chars, lowercase + hyphens only>"
```

### 2. Init + plan + apply

```bash
terraform init
terraform plan -var-file=envs/dev.tfvars
terraform apply -var-file=envs/dev.tfvars   # type 'yes' when prompted

```

### 3. Destroy when done

```bash
terraform destroy -var-file=envs/dev.tfvars
# Purge soft-deleted KVs (90-day retention blocks same-name redeploy):
az keyvault list-deleted --query "[?contains(properties.vaultId, '<project>')].name" -o tsv \
  | xargs -I{} az keyvault purge --name {}
```

---


---

## Destroy (clean slate)

```bash
# Terraform destroy
terraform destroy -var-file=envs/dev.tfvars

# Purge soft-deleted KVs (90-day retention blocks same-name redeploy)
az keyvault list-deleted --query "[?contains(properties.vaultId, '$PROJECT')].name" -o tsv \
  | xargs -I{} az keyvault purge --name {}
```

---

## Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `Key Vault name already in taken` | soft-deleted KV from prior deploy | `az keyvault purge` or change project_name |
| `Resource already exists` | state drift (state empty but Azure has resources) | Import or destroy out-of-band resources |
| `403 on Key Vault from runner` | `enable_kv_harden=true` with GitHub-hosted runner | Switch to self-hosted or temporarily set false |
| `VnetReplicationToPrimaryNetworkBlocked` (PG Flex HA) | NSG rule, missing `Microsoft.Storage` SE, or VNet lock | See wiki `erreurs/pg-flex-ha-needs-storage-service-endpoint` |
| Plan shows destroy on platform resources | Wrong `tfstate` key or using dev tfvars in prod | Verify `backend.tf` key and `envs/prod.tfvars` |

For anything else: `README.md` section "Troubleshooting" or file an issue.
