output "foundation_scope_id" {
  value = boundary_scope.foundation.id
}

output "boundary_auth_method_oidc_id" {
  value = boundary_auth_method_oidc.azuread.id
}

output "boundary_auth_method_password_id" {
  value = boundary_auth_method.password.id
}

output "random_password_admin_pass_result" {
  value = random_password.admin_pass.result
}
