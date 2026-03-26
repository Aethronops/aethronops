# ============================================================
# AETHRONOPS v2 — MANAGEMENT GROUPS
# Pattern  : governance-organization / premium
# Tier     : premium
# ============================================================
# DO NOT EDIT MANUALLY — Regenerate via AethronOps
# ============================================================

# ──────────────────────────────────────────────────────────
# BRICK : MANAGEMENT-GROUP
# Resource :  (native azurerm)
# CAF : GOV-1, NAMING-1
# MCSB : GS-2, AM-2
# Ref : https://learn.microsoft.com/security/benchmark/azure/mcsb-governance-strategy
# RGPD : ART-25
# NIS2 : ART-21-2a
# ──────────────────────────────────────────────────────────
resource "azurerm_management_group" "management_group" {
  name         = "mg-${local.name_prefix}"
  display_name = "Landing Zones"
}
