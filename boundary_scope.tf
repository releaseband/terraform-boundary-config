resource "boundary_scope" "global" {
  global_scope = true
  description  = "Global Scope"
  name         = "global"
  scope_id     = "global"
}

resource "boundary_scope" "org" {
  name                     = var.eks_cluster_name
  description              = var.eks_cluster_name
  scope_id                 = boundary_scope.global.id
  auto_create_admin_role   = false
  auto_create_default_role = false
}

## Use password auth method
resource "boundary_auth_method" "password" {
  name     = "org Password"
  scope_id = boundary_scope.org.id
  type     = "password"
}


resource "boundary_role" "global_anon_listing" {
  scope_id = "global"
  grant_strings = [
    "ids=*;type=auth-method;actions=list,authenticate",
    "ids=*;type=scope;actions=list,no-op",
    "ids={{account.id}};actions=read,change-password",
    "ids=*;type=scope;actions=list,no-op"
  ]
  principal_ids = ["u_anon"]
}

resource "boundary_role" "org_anon_listing" {
  scope_id = boundary_scope.org.id
  grant_strings = [
    "ids=*;type=auth-method;actions=list,authenticate",
    "type=scope;actions=list",
    "ids={{account.id}};actions=read,change-password",
    "ids=*;type=scope;actions=list,no-op"
  ]
  principal_ids = ["u_anon"]
}

resource "boundary_scope" "foundation" {
  name                     = "foundation"
  description              = "foundation"
  scope_id                 = boundary_scope.org.id
  auto_create_admin_role   = false
  auto_create_default_role = false
}

resource "boundary_role" "read_only" {
  scope_id      = boundary_scope.foundation.id
  grant_strings = ["ids=*;type=*;actions=read,list,no-op"]
  principal_ids = ["u_auth"]
}
