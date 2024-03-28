resource "random_password" "admin_pass" {
  length  = 20
  special = false
}

resource "boundary_account_password" "admin_accs" {
  name           = "admin"
  description    = "Admin account"
  type           = "password"
  login_name     = "admin"
  password       = random_password.admin_pass.result
  auth_method_id = boundary_auth_method.password.id
}

resource "boundary_user" "admin_users" {
  name        = "admin"
  description = "User resource for admin"
  scope_id    = boundary_scope.org.id
  account_ids = [boundary_account_password.admin_accs.id]
}

resource "vault_generic_secret" "admin_pass" {
  path      = "secrets/boundary/admin"
  data_json = <<EOT
{
  "pass":"${random_password.admin_pass.result}",
  "id":"${boundary_user.admin_users.id}"
}
EOT
}

resource "boundary_role" "org_admin_password" {
  name          = "org_admin_password"
  scope_id      = boundary_scope.org.id
  grant_strings = ["ids=*;type=*;actions=*"]
  principal_ids = [boundary_user.admin_users.id]
}

resource "boundary_role" "global_admin_password" {
  name          = "global_admin_password"
  scope_id      = boundary_scope.global.id
  grant_strings = ["ids=*;type=*;actions=*"]
  principal_ids = [boundary_user.admin_users.id]
}