# ============================================================
# AETHRONOPS v2 — VARIABLES
# ============================================================

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
  default     = "aethronops-v2"
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

variable "enable_resource_locks" {
  description = "Enable CanNotDelete locks on critical resources (ISO 27001 A.8.3). Disable before terraform destroy."
  type        = bool
  default     = false
  # Set to true in production — prevents accidental deletion of RG, Key Vault, etc.
}

variable "policy_enforcement_mode" {
  description = "Enable Azure Policy enforcement (true = Deny, false = Audit only)"
  type        = bool
  default     = false  # Audit by default — change to true for Deny mode
}

variable "rbac_contributor_group_id" {
  description = "Entra ID group Object ID for the Contributor role (leave empty to disable)"
  type        = string
  default     = ""
}

variable "rbac_owner_group_id" {
  description = "Entra ID group Object ID for the Owner role (leave empty to disable)"
  type        = string
  default     = ""
}

variable "rbac_reader_group_id" {
  description = "Entra ID group Object ID for the Reader role (leave empty to disable)"
  type        = string
  default     = ""
}

variable "rbac_security_reader_group_id" {
  description = "Entra ID group Object ID for the Security Reader role (leave empty to disable)"
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
