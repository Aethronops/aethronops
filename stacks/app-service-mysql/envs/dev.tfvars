# ============================================================
# AethronOps — Dev Mode
# Stack: app-service-mysql | Generated: 2026-04-28
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

# App runtime — change to match your application
app_runtime         = "python"  # python | node | dotnet | java | php
app_runtime_version = "3.12"    # python: 3.12 | node: 22-lts | dotnet: 8.0 | java: 17 | php: 8.3
health_check_path   = "/health" # Your app health endpoint

