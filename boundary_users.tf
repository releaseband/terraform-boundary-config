resource "random_password" "pass" {
  for_each = toset(var.users)
  length   = 16
  special  = false
}

resource "boundary_account_password" "user_acc" {
  for_each       = toset(var.users)
  name           = each.key
  description    = "User account for ${each.key}"
  type           = "password"
  login_name     = lower(each.key)
  password       = random_password.pass[each.key].result
  auth_method_id = boundary_auth_method.password.id
}


resource "boundary_user" "users" {
  for_each    = toset(var.users)
  name        = each.key
  description = "User resource for ${each.key}"
  scope_id    = boundary_scope.org.id
  account_ids = [boundary_account_password.user_acc[each.key].id]
}


resource "vault_generic_secret" "user_pass" {
  for_each  = toset(var.users)
  path      = "secrets/boundary/${each.key}"
  data_json = <<EOT
{
  "pass":"${random_password.pass[each.key].result}",
  "id":"${boundary_user.users[each.key].id}"
}
EOT
}

resource "boundary_group" "readonly" {
  name        = "read-only"
  description = "Organization group for readonly users"
  member_ids  = [for user in boundary_user.users : user.id]
  scope_id    = boundary_scope.org.id
}



resource "boundary_role" "organization_readonly" {
  name          = "Read-only"
  description   = "Read-only role"
  principal_ids = [boundary_group.readonly.id]
  grant_strings = ["id=*;type=*;actions=read,list,no-op"]
  scope_id      = boundary_scope.org.id
}

resource "boundary_group" "global_readonly" {
  name        = "read-only"
  description = "Organization group for readonly users"
  member_ids  = [for user in boundary_user.users : user.id]
  scope_id    = boundary_scope.global.id
}



resource "boundary_role" "global_readonly" {
  name          = "Read-only"
  description   = "Read-only role"
  principal_ids = [boundary_group.readonly.id]
  grant_strings = ["id=*;type=*;actions=read,list,no-op"]
  scope_id      = boundary_scope.global.id
}