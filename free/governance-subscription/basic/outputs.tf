# ============================================================
# AETHRONOPS v2 — OUTPUTS
# ============================================================

output "resource_group_id" {
  description = "ID du resource group principal"
  value       = module.resource_group.resource_id
}

output "resource_group_name" {
  description = "Nom du resource group principal"
  value       = module.resource_group.name
}

output "log_analytics_id" {
  description = "ID du Log Analytics Workspace"
  value       = module.log_analytics.resource_id
}
