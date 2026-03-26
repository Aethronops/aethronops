# ============================================================
# AETHRONOPS v2 — DEFENDER
# Pattern  : governance-subscription / standard
# Tier     : standard
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : SECURITY-CONTACT
# Resource :  (native azurerm)
# CAF : SEC-1
# MCSB : IR-2
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-incident-response
# RGPD : ART-33
# NIS2 : ART-21-2b
# ──────────────────────────────────────────────────────────
resource "azurerm_security_center_contact" "main" {
  name                = "default"
  email               = var.security_contact_email
  alert_notifications = true
  alerts_to_admins    = true
}

# ──────────────────────────────────────────────────────────
# BRICK : DEFENDER-PLANS
# Resource :  (native azurerm)
# CAF : SEC-1, MON-1
# MCSB : LT-1, ES-1, DP-2
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-logging-threat-detection
# RGPD : ART-32, ART-33
# NIS2 : ART-21-2b, ART-21-2e
# ──────────────────────────────────────────────────────────
resource "azurerm_security_center_subscription_pricing" "virtualmachines" {
  tier          = "Standard"
  resource_type = "VirtualMachines"
  subplan       = "P1"
}

resource "azurerm_security_center_subscription_pricing" "storageaccounts" {
  tier          = "Standard"
  resource_type = "StorageAccounts"
}

resource "azurerm_security_center_subscription_pricing" "keyvaults" {
  tier          = "Standard"
  resource_type = "KeyVaults"
}

resource "azurerm_security_center_subscription_pricing" "sqlservers" {
  tier          = "Standard"
  resource_type = "SqlServers"
}

resource "azurerm_security_center_subscription_pricing" "opensourcerelationaldatabases" {
  tier          = "Standard"
  resource_type = "OpenSourceRelationalDatabases"
}

