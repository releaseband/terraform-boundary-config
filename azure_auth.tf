data "azuread_client_config" "current" {}

resource "azuread_group" "main" {
  display_name     = "Boundary ${var.eks_cluster_name} users"
  security_enabled = true
}

resource "azuread_group" "admins" {
  display_name     = "Boundary ${var.eks_cluster_name} admins"
  security_enabled = true
}
data "azuread_user" "main" {
  for_each            = toset(concat(var.admin_users_azure, var.users_loki_azure))
  user_principal_name = each.key
}


resource "azuread_group_member" "admin" {
  for_each         = toset(var.admin_users_azure)
  group_object_id  = azuread_group.admins.id
  member_object_id = data.azuread_user.main[each.key].id
}

resource "azuread_app_role_assignment" "admins" {
  app_role_id         = "00000000-0000-0000-0000-000000000000"
  principal_object_id = azuread_group.admins.object_id
  resource_object_id  = azuread_service_principal.main.object_id
}

resource "azuread_application" "main" {
  display_name = "Boundary ${var.eks_cluster_name}"

  identifier_uris = [
    "https://boundary.${var.domain_name}/v1/auth-methods/oidc:authenticate:callback",
  ]
  web {
    redirect_uris = [
      "https://boundary.${var.domain_name}/v1/auth-methods/oidc:authenticate:callback",
    ]
  }
  group_membership_claims = ["All"]

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All
      type = "Role"
    }

    resource_access {
      id   = "b4e74841-8e56-480b-be8b-910348b18b4c" # User.ReadWrite
      type = "Scope"
    }

    resource_access {
      id   = "98830695-27a2-44f7-8c18-0c3ebc9698f6" # GroupMember.Read.All
      type = "Scope"
    }
  }
}

resource "azuread_service_principal" "main" {
  client_id = azuread_application.main.application_id
  feature_tags {
    enterprise = true
  }
}


resource "azuread_application_password" "main" {
  application_id    = azuread_application.main.id
  end_date_relative = "87600h" # 10 year
}

resource "boundary_auth_method_oidc" "azuread" {
  scope_id             = boundary_scope.org.id
  issuer               = "https://login.microsoftonline.com/${data.azuread_client_config.current.tenant_id}/v2.0"
  client_id            = azuread_application.main.application_id
  client_secret        = azuread_application_password.main.value
  callback_url         = "https://boundary.${var.domain_name}/v1/auth-methods/oidc:authenticate:callback"
  signing_algorithms   = ["RS256"]
  api_url_prefix       = "https://boundary.${var.domain_name}"
  name                 = "Microsoft"
  is_primary_for_scope = false
  claims_scopes        = ["email", "profile"]
}

resource "boundary_managed_group" "admin" {
  auth_method_id = boundary_auth_method_oidc.azuread.id
  description    = "Boundary Admins managed group"
  name           = "BoundaryAdmins"
  filter         = "\"${azuread_group.admins.object_id}\" in \"/token/groups\""
}

resource "boundary_managed_group" "readonly" {
  auth_method_id = boundary_auth_method_oidc.azuread.id
  description    = "Boundary redonly managed group"
  name           = "BoundaryReadonly"
  filter         = "\"${azuread_group.main.object_id}\" in \"/token/groups\""
}

resource "boundary_role" "org_admin" {
  name          = "org_admin"
  scope_id      = boundary_scope.org.id
  grant_strings = ["id=*;type=*;actions=*"]
  principal_ids = [boundary_managed_group.admin.id]
}

resource "boundary_role" "global_admin" {
  name          = "global_admin"
  scope_id      = boundary_scope.global.id
  grant_strings = ["id=*;type=*;actions=*"]
  principal_ids = [boundary_managed_group.admin.id]
}

resource "boundary_role" "admin" {
  scope_id      = boundary_scope.foundation.id
  grant_strings = ["id=*;type=*;actions=*"]
  principal_ids = [boundary_managed_group.admin.id]
}