# ============================================================
# AETHRONOPS v3 — DATABASE
# Pattern  : container-apps-mysql / dev
# Tier     : dev
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : MYSQL-FLEXIBLE
# Module AVM : Azure/avm-res-dbformysql-flexibleserver/azurerm
# Version    : 0.1.6
# MySQL Flexible Server PaaS for WordPress, Laravel, PHP.
# Configurable maintenance windows, scheduled stop for dev/test.
# CAF : DATA-1, DATA-2
# Ref : https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/mysql
# MCSB : DP-4, NS-2, DP-3
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-data-protection
# RGPD : ART-32
# NIS2 : ART-21-2c, ART-21-2e
# ──────────────────────────────────────────────────────────
module "mysql_flexible" {
  source  = "Azure/avm-res-dbformysql-flexibleserver/azurerm"
  version = "0.1.6"

  name                = "${trimsuffix(substr("mysql-${local.name_prefix}", 0, 58), "-")}-${random_string.storage_suffix.result}"
  location            = var.location
  resource_group_name = module.resource_group.name

  administrator_login    = var.mysql_admin_login
  administrator_password = random_password.mysql_admin.result
  sku_name               = "B_Standard_B1ms"
  storage = {
    size_gb   = 20
    auto_grow = var.db_storage_autogrow
  }
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  public_network_access        = "Enabled"
  maintenance_window           = null
  high_availability            = null

  # MySQL security hardening (basic tier)
  server_configuration = {
    audit_log_enabled = { name = "audit_log_enabled", value = "ON" }
    require_ssl       = { name = "require_secure_transport", value = "ON" }
    tls_version       = { name = "tls_version", value = "TLSv1.3" }
    slow_query_log    = { name = "slow_query_log", value = "ON" }
  }

  # Override AVM default — Allow Azure Services only (MCSB NS-2)
  firewall_rules = {
    allow_azure_services = {
      name             = "AllowAzureServices"
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    }
  }

  diagnostic_settings = {
    default = {
      name                  = trimsuffix(substr("diag-mysql_flexible-${local.name_prefix}", 0, 90), "-")
      workspace_resource_id = module.log_analytics.resource_id
      log_groups            = ["allLogs"]
    }
  }

  tags             = local.common_tags
  enable_telemetry = false
}
