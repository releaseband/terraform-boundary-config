<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48 |
| <a name="requirement_boundary"></a> [boundary](#requirement\_boundary) | >= 1.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 3.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.48 |
| <a name="provider_boundary"></a> [boundary](#provider\_boundary) | >= 1.1 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.4 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 3.11 |

## Resources

| Name | Type |
|------|------|
| [boundary_account_password.admin_accs](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/account_password) | resource |
| [boundary_account_password.user_acc](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/account_password) | resource |
| [boundary_auth_method.password](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/auth_method) | resource |
| [boundary_group.global_readonly](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/group) | resource |
| [boundary_group.loki](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/group) | resource |
| [boundary_group.readonly](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/group) | resource |
| [boundary_host_catalog_static.host_catalog_loki](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/host_catalog_static) | resource |
| [boundary_host_set_static.host_set_loki](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/host_set_static) | resource |
| [boundary_host_static.host_loki](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/host_static) | resource |
| [boundary_role.admin](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/role) | resource |
| [boundary_role.global_admin](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/role) | resource |
| [boundary_role.global_anon_listing](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/role) | resource |
| [boundary_role.global_readonly](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/role) | resource |
| [boundary_role.loki](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/role) | resource |
| [boundary_role.org_admin](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/role) | resource |
| [boundary_role.org_anon_listing](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/role) | resource |
| [boundary_role.organization_readonly](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/role) | resource |
| [boundary_role.read_only](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/role) | resource |
| [boundary_scope.foundation](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/scope) | resource |
| [boundary_scope.global](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/scope) | resource |
| [boundary_scope.org](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/scope) | resource |
| [boundary_target.loki](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/target) | resource |
| [boundary_user.admin_users](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/user) | resource |
| [boundary_user.users](https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/user) | resource |
| [random_password.admin_pass](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.pass](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [vault_generic_secret.admin_pass](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_secret) | resource |
| [vault_generic_secret.user_pass](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_secret) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [vault_generic_secret.loki](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_key_id"></a> [access\_key\_id](#input\_access\_key\_id) | aws access key id for boundary provider | `string` | n/a | yes |
| <a name="input_access_key_secret"></a> [access\_key\_secret](#input\_access\_key\_secret) | aws key secret for boundary provider | `string` | n/a | yes |
| <a name="input_admin_users"></a> [admin\_users](#input\_admin\_users) | list of boundary admin users | `list(string)` | <pre>[<br>  "admin"<br>]</pre> | no |
| <a name="input_aws_kms_key_id"></a> [aws\_kms\_key\_id](#input\_aws\_kms\_key\_id) | kms key id for boundary provider | `string` | n/a | yes |
| <a name="input_boundary_users_loki"></a> [boundary\_users\_loki](#input\_boundary\_users\_loki) | list of users with access to loki across the boundary | `list(string)` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain for dns records | `string` | n/a | yes |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of EKS cluster for provider config and nodeselectors | `string` | n/a | yes |
| <a name="input_users"></a> [users](#input\_users) | list of boundary readonly users | `list(string)` | n/a | yes |
| <a name="input_vault_token"></a> [vault\_token](#input\_vault\_token) | Token for vault provider | `string` | n/a | yes |
<!-- END_TF_DOCS -->