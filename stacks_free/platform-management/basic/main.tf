# ============================================================
# AETHRONOPS v2 — GENERATED TERRAFORM
# Pattern  : platform-management / basic
# Tier     : basic
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
  required_version = ">= 1.10, < 2.0"
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
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  storage_use_azuread       = true
}

provider "azapi" {}

provider "random" {}

resource "random_string" "storage_suffix" {
  length  = 4
  special = false
  upper   = false
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
  name_prefix  = lower(join("-", local.name_parts))
  name_slug    = lower(join("", [for s in local.name_parts : replace(s, "-", "")]))
  rg_name      = "rg-${local.name_prefix}"

  # ── Enterprise Tags ──────────────────────────────────────────────
  # Mandatory tags on EVERY resource (CAF governance + MCSB AM-1 + RGPD Art.30)
  # custom_tags allows enterprises to add their own mandatory tags without
  # modifying generated code (e.g. compliance_framework, ticket_number).
  # Azure tag limit: 50 per resource, but some services (Automation Account)
  # have lower limits. Keep common_tags ≤ 15 to stay safe everywhere.
  common_tags = merge(var.tags, {
    # ── Identity & ownership ──
    environment         = var.environment
    project             = var.project_name
    owner               = var.owner
    cost_center         = var.cost_center

    # ── Security & compliance ──
    data_classification = var.data_classification
    confidentiality     = var.confidentiality_level

    # ── Operations ──
    stack_type          = "platform-management"
    tier                = "basic"
    deployment_date     = "managed-by-ci"  # Set by CI/CD pipeline or manual deploy
  })
}
