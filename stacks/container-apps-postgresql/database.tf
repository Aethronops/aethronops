# ============================================================
# AETHRONOPS v3 — DATABASE
# Pattern  : container-apps-postgresql / dev
# Tier     : dev
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : POSTGRESQL-FLEXIBLE
# Module AVM : Azure/avm-res-dbforpostgresql-flexibleserver/azurerm
# Version    : 0.2.0
# PostgreSQL Flexible Server PaaS for Django, Rails, Node.js+pg.
# Scheduled stop to reduce costs, built-in cross-zone HA.
# CAF : DATA-1, DATA-2
# Ref : https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/postgresql
# MCSB : DP-4, NS-2, DP-3
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-data-protection
# RGPD : ART-32
# NIS2 : ART-21-2c, ART-21-2e
# ──────────────────────────────────────────────────────────
module "postgresql_flexible" {
  source  = "Azure/avm-res-dbforpostgresql-flexibleserver/azurerm"
  version = "0.2.0"

  name                = "${trimsuffix(substr("psql-${local.name_prefix}", 0, 58), "-")}-${random_string.storage_suffix.result}"
  location            = var.location
  resource_group_name = module.resource_group.name

  administrator_login           = var.enable_db_passwordless ? null : var.postgresql_admin_login
  administrator_password        = var.enable_db_passwordless ? null : random_password.pg_admin.result
  sku_name                      = var.postgresql_sku
  storage_mb                    = var.postgresql_storage_mb
  storage_tier                  = "P4"
  auto_grow_enabled             = var.db_storage_autogrow
  server_version                = var.postgresql_version
  backup_retention_days         = var.postgresql_backup_retention_days
  geo_redundant_backup_enabled  = false
  public_network_access_enabled = true
  # Scheduled maintenance window (day + hour UTC)
  # Azure applies patches with <30s downtime, 5-day advance notice
  maintenance_window = var.db_maintenance_day == "" ? null : {
    day_of_week  = var.db_maintenance_day == "Sunday" ? 0 : var.db_maintenance_day == "Monday" ? 1 : var.db_maintenance_day == "Tuesday" ? 2 : var.db_maintenance_day == "Wednesday" ? 3 : var.db_maintenance_day == "Thursday" ? 4 : var.db_maintenance_day == "Friday" ? 5 : 6
    start_hour   = var.db_maintenance_hour
    start_minute = 0
  }
  high_availability = null

  server_configuration = {
    require_ssl         = { name = "require_secure_transport", config = "ON" }
    ssl_min_version     = { name = "ssl_min_protocol_version", config = "TLSv1.3" }
    log_checkpoints     = { name = "log_checkpoints", config = "ON" }
    log_connections     = { name = "log_connections", config = "ON" }
    password_encryption = { name = "password_encryption", config = "scram-sha-256" }
  }

  # Override AVM default (AllowAll 0.0.0.0-255.255.255.255) — MCSB NS-2
  # Allow Azure Services only (App Service → PostgreSQL via Azure backbone)
  firewall_rules = {
    allow_azure_services = {
      name             = "AllowAzureServices"
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    }
  }

  diagnostic_settings = {
    default = {
      name                  = trimsuffix(substr("diag-postgresql_flexible-${local.name_prefix}", 0, 90), "-")
      workspace_resource_id = module.log_analytics.resource_id
      log_groups            = ["allLogs"]
    }
  }

  tags             = local.common_tags
  enable_telemetry = false
}
