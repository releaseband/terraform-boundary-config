variable "eks_cluster_name" {
  description = "Name of EKS cluster for provider config and nodeselectors"
  type        = string
}

variable "domain_name" {
  description = "Domain for dns records"
  type        = string
}

variable "aws_kms_key_id" {
  description = "kms key id for boundary provider"
  type        = string
}

variable "access_key_id" {
  description = "aws access key id for boundary provider"
  type        = string
}
variable "access_key_secret" {
  description = "aws key secret for boundary provider"
  type        = string
}

variable "vault_token" {
  description = "Token for vault provider"
  type        = string
}

variable "boundary_users_loki" {
  description = "list of users with access to loki across the boundary"
  type        = list(string)
}

variable "users" {
  description = "list of boundary readonly users"
  type        = list(string)
}

variable "users_loki_azure" {
  description = "list of users with access to loki across the boundary"
  type        = list(string)
}

variable "admin_users_azure" {
  description = "list of admins with access the boundary"
  type        = list(string)
}