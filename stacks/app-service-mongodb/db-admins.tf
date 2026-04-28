# ============================================================
# AETHRONOPS v3 — DB ADMINS ENTRA GROUP
# ============================================================
# Microsoft CAF 2026 : DB admin = Entra *group* (not a MI).
# Lets human operators connect with their own Entra identity
# and membership is managed centrally without touching the DB.
# ============================================================

# The admin group itself. Owned by the current deploy principal.
resource "azuread_group" "db_admins" {
  count            = var.enable_db_passwordless ? 1 : 0
  display_name     = coalesce(var.db_admin_group_name, "db-admins-${local.name_prefix}-${random_string.storage_suffix.result}")
  security_enabled = true
  owners           = [data.azurerm_client_config.current.object_id]
}

# Wait 3 minutes for the new Managed Identity to propagate from Azure
# Resource Manager to Microsoft Entra Graph. Without this, the next
# `azuread_group_member` call silently records a reference to a not-yet-
# resolved directory object → the MI never appears as an active group
# member → the app cannot authenticate to the DB with passwordless Entra.
# Microsoft documents 5-10 min as safe; 3 min is a pragmatic compromise.
resource "time_sleep" "wait_mi_graph_propagation" {
  count           = var.enable_db_passwordless ? 1 : 0
  create_duration = "180s"
  depends_on      = [module.managed_identity]
}

# App Service Managed Identity is always a member (app passwordless access).
resource "azuread_group_member" "db_admin_mi" {
  count            = var.enable_db_passwordless ? 1 : 0
  group_object_id  = azuread_group.db_admins[0].object_id
  member_object_id = module.managed_identity.principal_id
  depends_on       = [time_sleep.wait_mi_graph_propagation]
}

# Extra operators (humans, groups, SPs) declared in tfvars.
resource "azuread_group_member" "db_admin_extra" {
  for_each         = var.enable_db_passwordless ? toset(var.db_admin_members) : toset([])
  group_object_id  = azuread_group.db_admins[0].object_id
  member_object_id = each.value
}

# ──────────────────────────────────────────────────────────
# MongoDB (Azure DocumentDB) Entra ID authentication 2026
# AVM module 0.1.0 doesn't expose authConfig, so we use azapi:
#  1. Enable MicrosoftEntraID mode on the cluster
#  2. Register the MI (ServicePrincipal) as a cluster user
#  3. Register each human in db_admin_members (User) individually
# Azure API 2025-09-01 returns Internal Server Error when
# principalType = "Group" is used on mongoClusters/users, so we
# register each principal individually with the exact type.
# Ref: https://learn.microsoft.com/en-us/azure/documentdb/how-to-connect-role-based-access-control
# ──────────────────────────────────────────────────────────
resource "azapi_update_resource" "mongo_auth_config" {
  count       = var.enable_db_passwordless ? 1 : 0
  type        = "Microsoft.DocumentDB/mongoClusters@2025-09-01"
  resource_id = module.mongo_cluster.resource_id
  body = {
    properties = {
      authConfig = {
        allowedModes = ["MicrosoftEntraID", "NativeAuth"]
      }
    }
  }
}

# Register the App Service Managed Identity as a cluster user.
# "root" role on db "admin" = full admin privileges (MongoDB standard role).
resource "azapi_resource" "mongo_entra_admin_mi" {
  count     = var.enable_db_passwordless ? 1 : 0
  type      = "Microsoft.DocumentDB/mongoClusters/users@2025-09-01"
  name      = module.managed_identity.principal_id
  parent_id = module.mongo_cluster.resource_id
  body = {
    properties = {
      identityProvider = {
        type = "MicrosoftEntraID"
        properties = {
          principalType = "ServicePrincipal"
        }
      }
      roles = [
        {
          db   = "admin"
          role = "root"
        }
      ]
    }
  }
  depends_on = [azapi_update_resource.mongo_auth_config]
}

# Register each human operator listed in db_admin_members.
# Azure MongoDB (DocumentDB) expects one cluster user per human —
# Entra groups are not supported as a mongoClusters/users principalType.
# db_admin_members are assumed to be Entra User object IDs here.
resource "azapi_resource" "mongo_entra_admin_humans" {
  for_each  = var.enable_db_passwordless ? toset(var.db_admin_members) : toset([])
  type      = "Microsoft.DocumentDB/mongoClusters/users@2025-09-01"
  name      = each.value
  parent_id = module.mongo_cluster.resource_id
  body = {
    properties = {
      identityProvider = {
        type = "MicrosoftEntraID"
        properties = {
          principalType = "User"
        }
      }
      roles = [
        {
          db   = "admin"
          role = "root"
        }
      ]
    }
  }
  depends_on = [azapi_update_resource.mongo_auth_config]
}

