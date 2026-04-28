# ============================================================
# AETHRONOPS v3 — APP
# Pattern  : app-service-sql / dev
# Tier     : dev
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : APP-SERVICE-PLAN
# Resource : azurerm_service_plan (native azurerm)
# The App Service Plan defines the compute capacity (CPU/RAM)
# and SKU for your web application.
# Deployed as a native azurerm resource since there is no
# official dedicated AVM module to date.
# The SKU is automatically adapted to the chosen tier:
# B1 (dev/basic) -> P1v3 (standard) -> P3v3 (premium)
# CAF : APP-1
# Ref : https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/app-service-environment
# NIS2 : ART-21-2b
# ──────────────────────────────────────────────────────────
resource "azurerm_service_plan" "app_service_plan" {
  name                = "asp-${local.name_prefix}"
  resource_group_name = module.resource_group.name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B1"

  tags = local.common_tags
}

# ──────────────────────────────────────────────────────────
# BRICK : APP-SERVICE
# Module AVM : Azure/avm-res-web-site/azurerm
# Version    : 0.21.0
# Azure App Service is the PaaS platform for web applications.
# It eliminates VM management, OS maintenance, and patching.
# Continuous deployment, auto-scaling, VNet integration, managed identity.
# CAF : APP-1, SEC-3
# Ref : https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/app-service-environment
# MCSB : NS-1, NS-2, IM-1, DP-3
# RGPD : ART-32, ART-25
# NIS2 : ART-21-2b, ART-21-2h
# ──────────────────────────────────────────────────────────
module "app_service" {
  source  = "Azure/avm-res-web-site/azurerm"
  version = "0.21.0"

  name      = "${trimsuffix(substr("app-${local.name_prefix}", 0, 55), "-")}-${random_string.storage_suffix.result}"
  location  = var.location
  parent_id = module.resource_group.resource_id

  kind                          = "webapp"
  service_plan_resource_id      = azurerm_service_plan.app_service_plan.id
  https_only                    = true
  public_network_access_enabled = true
  vnet_route_all_traffic        = false
  site_config = {
    always_on                = false
    minimum_tls_version      = "1.2"
    ftps_state               = "Disabled"
    http2_enabled            = true
    remote_debugging_enabled = false
    health_check_path        = var.health_check_path
    application_stack        = local.app_runtime_stack
  }
  # BUG-017: disable AVM internal azapi diag_setting — use azurerm standalone instead
  diagnostic_settings = {}
  # Workaround: AVM avm-res-web-site validation bug on dapr_config (null check)
  dapr_config = {}
  managed_identities = {
    system_assigned            = true
    user_assigned_resource_ids = [module.managed_identity.resource_id]
  }
  app_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = module.application_insights.resource.connection_string
    AZURE_CLIENT_ID                       = module.managed_identity.client_id
    DATABASE_URL                          = "@Microsoft.KeyVault(SecretUri=${module.key_vault.uri}secrets/${var.project_name}-database-url)"
    DATABASE_TYPE                         = "sqlserver"
    KEY_VAULT_NAME                        = module.key_vault.name
    PROJECT_NAME                          = var.project_name
    ENVIRONMENT                           = var.environment
  }

  # BUG-064/065/069: wait for dependencies to propagate
  depends_on = [module.managed_identity]

  tags             = local.common_tags
  enable_telemetry = false
}
