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

output "key_vault_id" {
  description = "ID du Key Vault"
  value       = module.key_vault.resource_id
}

output "key_vault_uri" {
  description = "URI du Key Vault"
  value       = module.key_vault.uri
}

output "log_analytics_id" {
  description = "ID du Log Analytics Workspace"
  value       = module.log_analytics.resource_id
}

output "app_insights_id" {
  description = "Resource ID Application Insights"
  value       = module.application_insights.resource_id
}

output "storage_account_id" {
  description = "Resource ID du Storage Account"
  value       = module.storage_account.resource_id
}

output "storage_account_primary_endpoint" {
  description = "Endpoint primaire du Storage Account"
  value       = try(module.storage_account.resource.primary_blob_endpoint, "")
  sensitive   = true
}

output "managed_identity_id" {
  description = "Resource ID de la Managed Identity"
  value       = module.managed_identity.resource_id
}

output "managed_identity_client_id" {
  description = "Client ID de la Managed Identity"
  value       = try(module.managed_identity.resource.client_id, "")
  sensitive   = true
}

# ──────────────────────────────────────────────────────────
# PLATFORM-MANAGEMENT OUTPUTS — Shared monitoring IDs
# ──────────────────────────────────────────────────────────

output "log_analytics_workspace_id" {
  description = "Shared Log Analytics Workspace ID — used by spoke diagnostic settings (corp mode)"
  value       = module.log_analytics.resource_id
}

output "shared_storage_account_id" {
  description = "Shared Storage Account ID — used by spoke flow logs and audit"
  value       = module.storage_account.resource_id
}
