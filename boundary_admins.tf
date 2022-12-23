resource "random_password" "admin_pass" {
  for_each = toset(var.admin_users)
  length   = 20
  special  = false
}

resource "boundary_account_password" "admin_accs" {
  for_each       = toset(var.admin_users)
  name           = lower(each.key)
  description    = "Admin account for ${each.key}"
  type           = "password"
  login_name     = lower(each.key)
  password       = random_password.admin_pass[each.key].result
  auth_method_id = boundary_auth_method.password.id
}

resource "boundary_user" "admin_users" {
  for_each    = toset(var.admin_users)
  name        = each.key
  description = "User resource for ${each.key}"
  scope_id    = boundary_scope.org.id
  account_ids = [boundary_account_password.admin_accs[each.key].id]
}

resource "vault_generic_secret" "admin_pass" {
  for_each  = toset(var.admin_users)
  path      = "secrets/boundary/${each.key}"
  data_json = <<EOT
{
  "pass":"${random_password.admin_pass[each.key].result}",
  "id":"${boundary_user.admin_users[each.key].id}"
}
EOT
}

resource "boundary_role" "org_admin" {
  name          = "org_admin"
  scope_id      = boundary_scope.org.id
  grant_strings = ["id=*;type=*;actions=*"]
  principal_ids = concat(
    [for user in boundary_user.admin_users : user.id]
  )
}

resource "boundary_role" "global_admin" {
  name          = "global_admin"
  scope_id      = boundary_scope.global.id
  grant_strings = ["id=*;type=*;actions=*"]
  principal_ids = concat(
    [for user in boundary_user.admin_users : user.id]
  )
}