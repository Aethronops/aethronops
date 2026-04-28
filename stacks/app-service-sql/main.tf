# ============================================================
# AETHRONOPS v3 — GENERATED TERRAFORM
# Pattern  : app-service-sql / dev
# Tier     : dev
# Generated: auto
# ============================================================
#
# WARNING: This code is provided AS IS. It MUST be reviewed
# and validated by a qualified person (DevOps, Cloud Architect,
# or security team) before any deployment.
# NEVER run terraform apply on production without prior
# testing in dev/uat and approval from your RSSI/DPO.
#
# AethronOps is NOT responsible for:
#   - Azure costs incurred by deploying this code
#   - Security incidents, data breaches, or outages
#   - Regulatory non-compliance (NIS2, RGPD, DORA...)
#   - Any damage resulting from deploying without review
# See the Disclaimer section in README.md for full terms.
#
# ============================================================

terraform {
  required_version = ">= 1.12, < 2.0" # 1.11 required by AVM write-only attrs but has a bug serializing Ephemeral+Sensitive; 1.12 fixes it.
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.64"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.12"
    }
  }
}

provider "azurerm" {
  subscription_id     = var.subscription_id
  storage_use_azuread = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      # Recover soft-deleted secrets when re-creating them (Mode B re-applies
      # may hit secrets left soft-deleted by previous apply). Purge protection
      # stays enabled on the KV itself (enforced by AVM), only affects reuse.
      recover_soft_deleted_secrets      = true
      recover_soft_deleted_keys         = true
      recover_soft_deleted_certificates = true
    }
  }
}

provider "azapi" {}

provider "azuread" {}

provider "random" {}

resource "random_string" "storage_suffix" {
  length  = 4
  special = false
  upper   = false
}

# Admin password for SQL Server — auto-generated, stored in Key Vault
resource "random_password" "sql_admin" {
  length           = 24
  special          = true
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  override_special = "!@#$%&*()-_=+"
}

data "azurerm_client_config" "current" {}

locals {
  # ── Enterprise Naming Convention ──────────────────────────────────
  # Pattern: {prefix}-[org]-[bu]-{project}-{env}-{region}-[instance]
  # Segments in [] are optional — set the variable to "" to skip.
  # All names forced to lowercase for Azure global resource compatibility.
  # Source: Microsoft CAF + Azure resource naming constraints
  #
  # Examples:
  #   PME:          kv-myapp-dev-weu-001           (org="", bu="")
  #   ETI:          kv-acme-myapp-prd-weu-001      (org="acme")
  #   Grand compte: kv-bnpf-fin-trading-prd-weu-001 (org="bnpf", bu="fin")
  name_parts = compact([
    var.org_code,
    var.business_unit,
    var.project_name,
    var.environment,
    var.region_short,
    var.instance_number != "" ? var.instance_number : null,
  ])
  name_prefix = lower(join("-", local.name_parts))
  name_slug   = lower(join("", [for s in local.name_parts : replace(s, "-", "")]))
  rg_name     = "rg-${local.name_prefix}"

  # ── Enterprise Tags ──────────────────────────────────────────────
  # Mandatory tags on EVERY resource (CAF governance + MCSB AM-1 + RGPD Art.30)
  # custom_tags allows enterprises to add their own mandatory tags without
  # modifying generated code (e.g. compliance_framework, ticket_number).
  # Azure tag limit: 50 per resource, but some services (Automation Account)
  # have lower limits. Keep common_tags ≤ 15 to stay safe everywhere.
  common_tags = merge(var.tags, {
    # ── Identity & ownership ──
    environment = var.environment
    project     = var.project_name
    owner       = var.owner
    cost_center = var.cost_center
    managed_by  = "terraform" # MCSB AM-1 — tooling provenance

    # ── Security & compliance ──
    data_classification = var.data_classification
    confidentiality     = var.confidentiality_level

    # ── Operations ──
    stack_type      = "app-service-sql"
    tier            = "dev"
    deployment_date = "managed-by-ci" # Set by CI/CD pipeline or manual deploy
  })

  # ── Tag count hard-fail guard ───────────────────────────────────
  # Automation Account has a soft limit of 15 tags (vs 50 elsewhere).
  # Source: session-38 gotchas wiki + MS Learn subscription-service-limits.
  # Note: KV/SA name lengths are NOT guarded here — the engine uses
  # substr() at the resource level to truncate safely (KV max 23 chars,
  # SA max 24 chars by construction). See terraform_agent.py emit logic.
  _assert_tag_count = length(local.common_tags) <= 15 ? true : tobool("ERROR tag_count_exceeds_aa_limit: common_tags has ${length(local.common_tags)} entries, exceeds Automation Account soft limit of 15. Reduce var.tags custom entries.")
}

locals {
  # ── App Runtime Stack ────────────────────────────────────────
  # Resolves var.app_runtime + var.app_runtime_version into the
  # AVM application_stack object expected by avm-res-web-site.
  _runtime_map = {
    python = { python = { python_version = var.app_runtime_version } }
    node   = { node = { node_version = var.app_runtime_version } }
    dotnet = { dotnet = { dotnet_version = var.app_runtime_version } }
    java   = { java = { java_version = var.app_runtime_version } }
    php    = { php = { php_version = var.app_runtime_version } }
  }
  app_runtime_stack = local._runtime_map[var.app_runtime]
}
