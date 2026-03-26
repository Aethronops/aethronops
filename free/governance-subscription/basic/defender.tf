# ============================================================
# AETHRONOPS v2 — DEFENDER
# Pattern  : governance-subscription / basic
# Tier     : basic
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
