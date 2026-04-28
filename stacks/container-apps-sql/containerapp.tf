# ============================================================
# AETHRONOPS v3 — CONTAINERAPP
# Pattern  : container-apps-sql / dev
# Tier     : dev
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : CONTAINER-APP-ENVIRONMENT
# Module AVM : Azure/avm-res-app-managedenvironment/azurerm
# Version    : ~> 0.4
# Container App Environment is the managed environment that hosts
# Container Apps. It manages networking, logs, and scaling.
# AethronOps configures:
# -> Integrated Log Analytics (no Dapr sidecar by default)
# -> VNet integration in standard/premium
# -> Zone redundancy in premium
# -> Internal load balancer in standard/premium
# CAF : APP-2, NET-1
# WAF : NS-1, LT-1, IM-1
# RGPD : ART-21-2a, ART-21-2b
# ──────────────────────────────────────────────────────────
module "container_app_environment" {
  source  = "Azure/avm-res-app-managedenvironment/azurerm"
  version = "~> 0.4"

  name                = trimsuffix(substr("cae-${local.name_prefix}", 0, 60), "-")
  location            = var.location
  resource_group_name = module.resource_group.name

  log_analytics_workspace = {
    resource_id = module.log_analytics.resource_id
  }
  zone_redundancy_enabled        = false
  internal_load_balancer_enabled = false

  tags             = local.common_tags
  enable_telemetry = false
}

# ──────────────────────────────────────────────────────────
# BRICK : CONTAINER-APP
# Module AVM : Azure/avm-res-app-containerapp/azurerm
# Version    : ~> 0.7
# Container App is Azure's serverless container service.
# It supports automatic scaling (KEDA), revisions,
# and secrets via Key Vault.
# AethronOps configures:
# -> Placeholder image (to customize)
# -> Managed Identity for auth
# -> Ingress configured
# -> Min/max scaling rules
# CAF : APP-2, SEC-3
# WAF : IM-1, IM-3, NS-1
# RGPD : ART-21-2a, ART-21-2h
# ──────────────────────────────────────────────────────────
module "container_app" {
  source  = "Azure/avm-res-app-containerapp/azurerm"
  version = "~> 0.7"

  name                = trimsuffix(substr("ca-${local.name_prefix}", 0, 32), "-")
  location            = var.location
  resource_group_name = module.resource_group.name

  container_app_environment_resource_id = module.container_app_environment.resource_id
  template = {
    containers = [{
      name   = "app"
      image  = var.container_image
      cpu    = var.container_cpu
      memory = var.container_memory
    }]
    min_replicas = var.container_min_replicas
    max_replicas = var.container_max_replicas
  }
  ingress = {
    external_enabled = true
    target_port      = var.container_port
    transport        = "http"
    traffic_weight = [{
      latest_revision = true
      percentage      = 100
    }]
  }
  managed_identities = {
    user_assigned_resource_ids = [module.managed_identity.resource_id]
  }

  # BUG-064/065/069: wait for dependencies to propagate
  depends_on = [module.managed_identity]

  tags             = local.common_tags
  enable_telemetry = false
}
