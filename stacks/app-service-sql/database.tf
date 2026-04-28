# ============================================================
# AETHRONOPS v3 — DATABASE
# Pattern  : app-service-sql / dev
# Tier     : dev
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : SQL-DATABASE
# Module AVM : Azure/avm-res-sql-server/azurerm
# Version    : 0.1.6
# Azure SQL Database: PaaS relational database with T-SQL, 99.99% HA,
# automatic backups, point-in-time restore, TDE by default.
# CAF : DATA-1, DATA-2
# Ref : https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/sql-server
# MCSB : DP-4, NS-2, DP-3
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-data-protection
# RGPD : ART-32, ART-25
# NIS2 : ART-21-2c, ART-21-2e
# ──────────────────────────────────────────────────────────
module "sql_database" {
  source  = "Azure/avm-res-sql-server/azurerm"
  version = "0.1.6"

  name                = "${trimsuffix(substr("sql-${local.name_prefix}", 0, 58), "-")}-${random_string.storage_suffix.result}"
  location            = var.location
  resource_group_name = module.resource_group.name

  server_version               = "12.0"
  administrator_login          = var.enable_db_passwordless ? null : var.sql_admin_login
  administrator_login_password = var.enable_db_passwordless ? null : random_password.sql_admin.result
  databases = {
    "primary" = {
      name                           = "sqldb-${var.project_name}"
      sku_name                       = "S0"
      max_size_gb                    = 2
      geo_backup_enabled             = false
      zone_redundant                 = false
      maintenance_configuration_name = var.sql_maintenance_window
      short_term_retention_policy = {
        retention_days           = 7
        backup_interval_in_hours = 24
      }
    }
  }
  azuread_administrator = var.enable_db_passwordless ? {
    login_username              = azuread_group.db_admins[0].display_name
    object_id                   = azuread_group.db_admins[0].object_id
    tenant_id                   = data.azurerm_client_config.current.tenant_id
    azuread_authentication_only = true
    } : {
    login_username = var.sql_aad_admin_login
    object_id      = coalesce(var.sql_aad_admin_object_id, data.azurerm_client_config.current.object_id)
  }
  connection_policy                    = "Redirect"
  outbound_network_restriction_enabled = true
  public_network_access_enabled        = true

  tags             = local.common_tags
  enable_telemetry = false
}
