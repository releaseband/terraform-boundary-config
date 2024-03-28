resource "boundary_host_catalog_static" "host_catalog_loki" {
  name        = "loki"
  description = "loki"
  scope_id    = boundary_scope.foundation.id
}


resource "boundary_host_static" "host_loki" {
  name            = "loki"
  description     = "loki"
  address         = "loki-gateway.monitoring.svc.cluster.local"
  host_catalog_id = boundary_host_catalog_static.host_catalog_loki.id
}

resource "boundary_host_set_static" "host_set_loki" {
  name            = "loki"
  description     = "loki"
  host_catalog_id = boundary_host_catalog_static.host_catalog_loki.id
  host_ids        = [boundary_host_static.host_loki.id]
}


resource "boundary_target" "loki" {
  type                     = "tcp"
  name                     = "loki"
  description              = "loki"
  scope_id                 = boundary_scope.foundation.id
  default_port             = 80
  session_connection_limit = 100
  host_source_ids = [
    boundary_host_set_static.host_set_loki.id
  ]
}

data "vault_generic_secret" "loki" {
  for_each = toset(var.boundary_users_loki)
  path     = "secrets/boundary/${each.key}"
}

locals {
  boundary_loki_user_id = [
    for user in data.vault_generic_secret.loki : user.data["id"]
  ]
}

resource "boundary_group" "loki" {
  name        = "loki"
  description = "loki"
  member_ids  = local.boundary_loki_user_id
  scope_id    = boundary_scope.foundation.id
}

resource "boundary_role" "loki" {
  name          = "loki"
  description   = "loki"
  principal_ids = [boundary_group.loki.id]
  grant_strings = ["id=${boundary_target.loki.id};actions=authorize-session"]
  scope_id      = boundary_scope.foundation.id
}


# AZURE

resource "azuread_group" "loki" {
  display_name     = "Boundary ${var.eks_cluster_name} loki"
  security_enabled = true
}

resource "azuread_group_member" "loki" {
  for_each         = toset(var.users_loki_azure)
  group_object_id  = azuread_group.loki.id
  member_object_id = data.azuread_user.main[each.key].id
}


resource "boundary_role" "loki_azure" {
  name          = "loki-azure"
  description   = "loki-azure"
  principal_ids = [boundary_managed_group.loki.id]
  grant_strings = ["ids=${boundary_target.loki.id};actions=authorize-session"]
  scope_id      = boundary_scope.foundation.id
}

resource "boundary_managed_group" "loki" {
  auth_method_id = boundary_auth_method_oidc.azuread.id
  description    = "Boundary managed group: loki"
  name           = "loki-azure"
  filter         = "\"${azuread_group.loki.object_id}\" in \"/token/groups\""
}