# ============================================================
# AETHRONOPS v3 — VARIABLES
# ============================================================

variable "subscription_id" {
  description = "Azure Subscription ID — required for azurerm 4.x provider"
  type        = string
  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.subscription_id))
    error_message = "subscription_id must be a valid UUID. Run: az account show --query id -o tsv"
  }
}

variable "project_name" {
  description = "Project name (lowercase, hyphens only)"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "project_name must be lowercase and hyphens only."
  }
}

variable "environment" {
  description = "Target environment"
  type        = string
  validation {
    condition     = contains(["dev", "uat", "test", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, uat, test, staging, prod."
  }
}

variable "location" {
  description = "Primary Azure region"
  type        = string
  default     = "westeurope"
}

variable "region_short" {
  description = "Short region code (e.g. weu, frc)"
  type        = string
  default     = "weu"
}

# ──────────────────────────────────────────────────────────
# ENTERPRISE NAMING — Customize to match your organization
# Set org_code and business_unit to make resource names unique
# and identifiable across your Azure estate.
# ──────────────────────────────────────────────────────────

variable "org_code" {
  description = "Organization code (3-5 chars). Makes all resource names globally unique. (e.g. acme, bnpf, safr)"
  type        = string
  default     = ""

  validation {
    condition     = var.org_code == "" || can(regex("^[a-z0-9]{2,8}$", var.org_code))
    error_message = "org_code must be 2-8 lowercase alphanumeric characters, or empty."
  }
}

variable "business_unit" {
  description = "Business unit / department code (e.g. fin, hr, mkt, it, eng)"
  type        = string
  default     = ""

  validation {
    condition     = var.business_unit == "" || can(regex("^[a-z0-9]{2,8}$", var.business_unit))
    error_message = "business_unit must be 2-8 lowercase alphanumeric characters, or empty."
  }
}

variable "instance_number" {
  description = "Instance number for multiple deployments of the same stack (e.g. 001, 002)"
  type        = string
  default     = ""

  validation {
    condition     = var.instance_number == "" || can(regex("^[0-9]{1,3}$", var.instance_number))
    error_message = "instance_number must be 1-3 digits, or empty."
  }
}

variable "tags" {
  description = "Business tags applied to all resources"
  type        = map(string)
  default     = {}
}

# ──────────────────────────────────────────────────────────
# ENTRA ID GROUP WIRING — RBAC for human operators
# These map Entra ID group object IDs to Azure RBAC roles at the RG
# and Key Vault scopes. Leave empty to skip role assignment for a group.
# Customer creates groups in Phase 1 (see enterprise-deployment-roadmap).
# ──────────────────────────────────────────────────────────

variable "platform_admins_group_object_id" {
  description = "Entra ID group object ID for platform admins (Contributor on RG + Key Vault Administrator on KV). Empty = skip."
  type        = string
  default     = ""
  validation {
    condition     = var.platform_admins_group_object_id == "" || can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.platform_admins_group_object_id))
    error_message = "platform_admins_group_object_id must be a valid GUID or empty."
  }
}

variable "developers_group_object_id" {
  description = "Entra ID group object ID for developers (Reader on RG + Key Vault Secrets User on KV). Empty = skip."
  type        = string
  default     = ""
  validation {
    condition     = var.developers_group_object_id == "" || can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.developers_group_object_id))
    error_message = "developers_group_object_id must be a valid GUID or empty."
  }
}

variable "secret_readers_group_object_id" {
  description = "Entra ID group object ID for read-only secret consumers (Key Vault Secrets User on KV only). Empty = skip."
  type        = string
  default     = ""
  validation {
    condition     = var.secret_readers_group_object_id == "" || can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.secret_readers_group_object_id))
    error_message = "secret_readers_group_object_id must be a valid GUID or empty."
  }
}

variable "security_readers_group_object_id" {
  description = "Entra ID group for CISO/audit/compliance (Reader on sub + Log Analytics Reader + Security Reader for Defender findings). Empty = skip. Source: CAF Identity."
  type        = string
  default     = ""
  validation {
    condition     = var.security_readers_group_object_id == "" || can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.security_readers_group_object_id))
    error_message = "security_readers_group_object_id must be a valid GUID or empty."
  }
}

variable "network_admins_group_object_id" {
  description = "Entra ID group for network operations team (Network Contributor on platform RG — manages NSG rules, subnets, peerings, Private Endpoints). CAF recommends separation of network/compute duties. Empty = skip."
  type        = string
  default     = ""
  validation {
    condition     = var.network_admins_group_object_id == "" || can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.network_admins_group_object_id))
    error_message = "network_admins_group_object_id must be a valid GUID or empty."
  }
}

variable "devops_group_object_id" {
  description = "Entra ID group for DevOps/SRE — app code deploy (Website Contributor + Web Plan Contributor + Container Apps Contributor + Key Vault Secrets Officer). Used in app-service-* and container-apps-* packs. Empty = skip."
  type        = string
  default     = ""
  validation {
    condition     = var.devops_group_object_id == "" || can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.devops_group_object_id))
    error_message = "devops_group_object_id must be a valid GUID or empty."
  }
}

variable "dba_group_object_id" {
  description = "Entra ID group for DBA team — Automation Operator (trigger runbooks) + PG/MySQL/SQL Entra admin natif (set on target DB separately via azuread_administrator). Used in db-admin-* packs. Empty = skip."
  type        = string
  default     = ""
  validation {
    condition     = var.dba_group_object_id == "" || can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.dba_group_object_id))
    error_message = "dba_group_object_id must be a valid GUID or empty."
  }
}

variable "finops_group_object_id" {
  description = "Entra ID group for FinOps/cost team (Cost Management Reader on subscription — view budgets, cost anomaly alerts, usage). Empty = skip."
  type        = string
  default     = ""
  validation {
    condition     = var.finops_group_object_id == "" || can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.finops_group_object_id))
    error_message = "finops_group_object_id must be a valid GUID or empty."
  }
}

# ──────────────────────────────────────────────────────────
# ENTERPRISE CUSTOMIZATION
# Adapt these variables to match your organization policies.
# ──────────────────────────────────────────────────────────

variable "custom_tags" {
  description = "Additional enterprise-mandated tags (merged into all resources)"
  type        = map(string)
  default     = {}
}

variable "iac_source" {
  description = "Infrastructure as Code source (operational tag)"
  type        = string
  default     = "aethronops"
}

# ──────────────────────────────────────────────────────────
# MANDATORY ENTERPRISE TAGS (CAF governance)
# These tags are required on all resources for cost tracking,
# ownership, and data classification (MCSB AM-1, RGPD Art.30).
# ──────────────────────────────────────────────────────────

variable "cost_center" {
  description = "Cost center code for billing attribution (e.g. IT-1234)"
  type        = string
  default     = "unassigned"

  validation {
    condition     = length(var.cost_center) > 0
    error_message = "cost_center tag is mandatory for enterprise governance."
  }
}

variable "owner" {
  description = "Team or person owning this infrastructure (e.g. team-platform@company.com)"
  type        = string
  default     = "unassigned"

  validation {
    condition     = length(var.owner) > 0
    error_message = "owner tag is mandatory for enterprise governance."
  }
}

variable "data_classification" {
  description = "Data classification level (public, internal, confidential, restricted) — RGPD/NIS2"
  type        = string
  default     = "internal"

  validation {
    condition     = contains(["public", "internal", "confidential", "restricted"], var.data_classification)
    error_message = "data_classification must be one of: public, internal, confidential, restricted."
  }
}

variable "confidentiality_level" {
  description = "Confidentiality level for security classification (C1-C4) — NIS2/DORA"
  type        = string
  default     = "C2"

  validation {
    condition     = contains(["C1", "C2", "C3", "C4"], var.confidentiality_level)
    error_message = "confidentiality_level must be C1 (public), C2 (internal), C3 (confidential), C4 (restricted)."
  }
}

variable "criticality" {
  description = "Business criticality — determines SLA, backup frequency, DR priority"
  type        = string
  default     = "medium"

  validation {
    condition     = contains(["low", "medium", "high", "critical"], var.criticality)
    error_message = "criticality must be low, medium, high, or critical."
  }
}

variable "operational_hours" {
  description = "Expected operational hours — drives auto-shutdown and alerting schedule"
  type        = string
  default     = "24x7"

  validation {
    condition     = contains(["24x7", "business-hours", "extended", "on-demand"], var.operational_hours)
    error_message = "operational_hours must be 24x7, business-hours, extended, or on-demand."
  }
}

variable "backup_policy" {
  description = "Backup policy tag — documents the backup strategy for auditors"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["none", "basic", "standard", "premium", "immutable"], var.backup_policy)
    error_message = "backup_policy must be none, basic, standard, premium, or immutable."
  }
}

variable "require_private_endpoints" {
  description = "Force private endpoints on all PaaS services (enterprise zero-trust)"
  type        = bool
  default     = false
}

variable "allowed_locations" {
  description = "Allowed Azure regions (enterprise geo-fencing policy)"
  type        = list(string)
  default     = ["westeurope", "francecentral"]
}

variable "security_contact_email" {
  description = "Security team email for alerts and notifications (required for Defender)"
  type        = string
  default     = "security@changeme.com"
}

variable "enable_security_contact" {
  description = "Enable Azure Security Center Contact (subscription-level singleton). Set false if already configured in the subscription."
  type        = bool
  default     = false
}

variable "enable_defender_plans" {
  description = "Enable Microsoft Defender for Cloud plans (subscription-level singletons). Cost: ~€45-50/month for a typical stack (PG + App Service + KV). Set false if already enabled in the subscription."
  type        = bool
  default     = false
}

variable "keyvault_network_hardened" {
  description = "Set Key Vault firewall to Deny (MCSB NS-2). Set to true AFTER first deploy when PE is active."
  type        = bool
  default     = false
}

variable "enable_resource_locks" {
  description = <<-EOT
    Enable Azure CanNotDelete locks on critical resources.
    
    CONSEQUENCES WHEN SET TO true:
      • Cannot deploy NEW workloads on this baseline (subnet delegation blocked,
        ScopeLocked 409 on KV/Storage/DB role_assignments).
      • Cannot rotate KV secrets without manual unlock cycle.
      • terraform destroy requires manual lock removal first.
    
    Leave false unless you understand the trade-off.
    For enterprise lock strategy guidance: aethronops.com/consulting
  EOT
  type        = bool
  default     = false
}

variable "enable_kv_harden" {
  description = "Harden Key Vault network: publicNetworkAccess=Disabled + networkAcls.defaultAction=Deny. REQUIRES a self-hosted GitHub runner in the VNet or Azure DevOps private agent — a GitHub-hosted runner cannot reach a hardened KV. Private Endpoint already isolates the KV; set true only for max-security customer policies."
  type        = bool
  default     = false
}

variable "enable_vnet_lock" {
  description = "Apply a CanNotDelete lock on the VNet. OFF by default: Azure blocks subnet delegation for PG Flex / App Service VNet integration if the VNet is locked. Enable ONLY after all workloads are deployed, and disable before adding/removing workloads. RG-level lock already covers accidental deletion (MCSB GV-3)."
  type        = bool
  default     = false
}

variable "policy_enforcement_mode" {
  description = "Enable Azure Policy enforcement (true = Deny, false = Audit only)"
  type        = bool
  default     = false # Audit by default — change to true for Deny mode
}

variable "mysql_admin_login" {
  description = "MySQL administrator login"
  type        = string
  default     = "mysqladmin"
}

# MySQL admin password is auto-generated via random_password.mysql_admin
# and stored in Key Vault. No variable needed — zero hardcoded secrets.

# ──────────────────────────────────────────────────────────
# APP SERVICE — Runtime and configuration
# ──────────────────────────────────────────────────────────

variable "app_runtime" {
  description = "Application runtime: python, node, dotnet, java, php"
  type        = string
  default     = "python"
  validation {
    condition     = contains(["python", "node", "dotnet", "java", "php"], var.app_runtime)
    error_message = "app_runtime must be one of: python, node, dotnet, java, php."
  }
}

variable "app_runtime_version" {
  description = "Runtime version (e.g. 3.12 for python, 22-lts for node, 8.0 for dotnet, 17 for java, 8.3 for php)"
  type        = string
  default     = "3.12"
}

variable "health_check_path" {
  description = "Health check endpoint path (e.g. /health, /api/health, /healthz)"
  type        = string
  default     = "/health"
}

# ──────────────────────────────────────────────────────────
# AZURE AUTO-MANAGEMENT — free features activated by default (2026)
# ──────────────────────────────────────────────────────────

variable "db_storage_autogrow" {
  description = "Auto-grow DB storage when reaching 85-90%. Free. Prevents disk-full outages. Only works with Premium SSD v1 or v2."
  type        = bool
  default     = true
}

variable "db_maintenance_day" {
  description = "Day of week for DB engine maintenance (patches). Azure applies patches with <30s downtime. Options: Sunday, Monday, ..., Saturday, or empty for Azure-managed."
  type        = string
  default     = "Sunday"
}

variable "db_maintenance_hour" {
  description = "Hour of day (UTC) for DB maintenance window (0-23). Recommended: 2 = 03:00 Paris, off-hours."
  type        = number
  default     = 2
  validation {
    condition     = var.db_maintenance_hour >= 0 && var.db_maintenance_hour <= 23
    error_message = "db_maintenance_hour must be 0-23."
  }
}

variable "enable_recommended_db_alerts" {
  description = "Deploy Azure recommended DB alerts (CPU > 80%, storage > 85%, connections > 80%, failed connections > 10/h, replica lag). Free. Emails sent to budget_alert_emails."
  type        = bool
  default     = true
}

variable "enable_db_passwordless" {
  description = "Enable Entra ID-only authentication (passwordless, 2026 Zero Trust baseline). App connects via Managed Identity token, no password stored. Default: true in prod, false in dev (faster iteration)."
  type        = bool
  default     = false
}

variable "db_admin_members" {
  description = "Extra Entra object IDs (users, groups, service principals) to add to the db-admins-<project> group as database administrators. The App Service Managed Identity is always added automatically. Example: [\"<your-entra-user-object-id>\"]"
  type        = list(string)
  default     = []
}

variable "db_admin_group_name" {
  description = "Optional custom display name for the DB admin Entra group. If empty, defaults to db-admins-<name_prefix>-<random>."
  type        = string
  default     = ""
}

variable "existing_subnet_data_name" {
  description = "Subnet name for database VNet integration (e.g. snet-data). Leave empty to use default snet-data."
  type        = string
  default     = ""
}

# ──────────────────────────────────────────────────────────
# FINOPS — Cost Optimization
# These variables control automated cost-saving features.
# ──────────────────────────────────────────────────────────

variable "enable_finops" {
  description = "Enable FinOps cost optimization resources (budget alerts, auto-shutdown, lifecycle policies)"
  type        = bool
  default     = false
}

variable "enable_cost_anomaly_alert" {
  description = "Enable cost anomaly alert (Azure limits subscriptions to 5 — set false if quota reached)"
  type        = bool
  default     = true
}

variable "monthly_budget_eur" {
  description = "Monthly Azure budget in EUR — triggers alerts at 50%, 80%, 100%, 120%"
  type        = number
  default     = 100
}

variable "budget_alert_emails" {
  description = "Email addresses for budget alert notifications"
  type        = list(string)
  default     = []
}

variable "finops_webhook_url" {
  description = "Webhook URL for Teams/Slack notifications (optional, leave empty to disable)"
  type        = string
  default     = ""
}

variable "enable_vm_schedule" {
  description = "Enable VM Start/Stop Automation with tag-based JSON schedules. Default: true in dev, false in production (stopping prod = downtime)."
  type        = bool
  default     = false
}

variable "enable_paas_schedule" {
  description = "Enable PaaS Start/Stop Automation (App Service scale-down, AKS stop, DB Flexible stop). Default: true in dev, false in production (stopping prod = downtime + lost revenue)."
  type        = bool
  default     = true
}

variable "schedule_timezone" {
  description = "Timezone for resource schedules (IANA format)"
  type        = string
  default     = "Europe/Paris"
}

variable "log_retention_days" {
  description = "Log Analytics retention in days (30=dev, 90=standard, 365=premium)"
  type        = number
  default     = 30
}

variable "enable_storage_lifecycle" {
  description = "Enable storage lifecycle management (auto-tier to Cool/Archive)"
  type        = bool
  default     = true
}

variable "storage_cool_after_days" {
  description = "Move blobs to Cool tier after N days"
  type        = number
  default     = 30
}

variable "storage_archive_after_days" {
  description = "Move blobs to Archive tier after N days (0 = disabled)"
  type        = number
  default     = 90
}
