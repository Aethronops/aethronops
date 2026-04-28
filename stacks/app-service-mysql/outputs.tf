# ============================================================
# AETHRONOPS v3 — OUTPUTS
# ============================================================

output "resource_group_id" {
  description = "Main resource group ID"
  value       = module.resource_group.resource_id
}

output "resource_group_name" {
  description = "Main resource group name"
  value       = module.resource_group.name
}

output "key_vault_id" {
  description = "Key Vault ID"
  value       = module.key_vault.resource_id
}

output "key_vault_uri" {
  description = "Key Vault URI"
  value       = module.key_vault.uri
}

output "log_analytics_id" {
  description = "Log Analytics Workspace ID"
  value       = module.log_analytics.resource_id
}

output "app_service_id" {
  description = "App Service resource ID"
  value       = module.app_service.resource_id
  sensitive   = true
}

output "app_insights_id" {
  description = "Resource ID Application Insights"
  value       = module.application_insights.resource_id
}

output "managed_identity_id" {
  description = "Managed Identity resource ID"
  value       = module.managed_identity.resource_id
}

output "managed_identity_client_id" {
  description = "Managed Identity client ID"
  value       = try(module.managed_identity.resource.client_id, "")
  sensitive   = true
}

output "mysql_id" {
  description = "MySQL Flexible Server resource ID"
  value       = module.mysql_flexible.resource_id
}

output "app_service_plan_id" {
  description = "App Service Plan resource ID"
  value       = azurerm_service_plan.app_service_plan.id
}
