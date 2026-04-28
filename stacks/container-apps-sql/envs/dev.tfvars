# ============================================================
# AethronOps — Dev Mode
# Stack: container-apps-sql | Generated: 2026-04-28
# ============================================================
#
# Fill in subscription_id and project_name, then deploy:
#   terraform init
#   terraform plan -var-file=envs/dev.tfvars
#   terraform apply -var-file=envs/dev.tfvars
#
# See README.md for full instructions (local + CI/CD modes).
# ============================================================

subscription_id = "00000000-0000-0000-0000-000000000000" # az account show --query id -o tsv
project_name    = "myproject"                            # max 8 chars, lowercase + hyphens only (KV limit = 24 chars)
environment     = "dev"
location        = "francecentral"
region_short    = "frc"

# Container — change image and sizing to match your app
container_image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
container_port   = 80
container_cpu    = 0.25    # 0.25 | 0.5 | 1 | 2 | 4
container_memory = "0.5Gi" # 0.5Gi | 1Gi | 2Gi | 4Gi | 8Gi

