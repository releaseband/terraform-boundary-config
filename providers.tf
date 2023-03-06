provider "boundary" {
  addr             = "https://boundary.${var.domain_name}"
  recovery_kms_hcl = <<EOT
  kms "awskms" {
  purpose    = "recovery"
  region     = "${data.aws_region.current.name}"
  access_key = "${var.access_key_id}"
  secret_key = "${var.access_key_secret}"
  kms_key_id = "${var.aws_kms_key_id}"
}
EOT
}

provider "vault" {
  address = "https://vault.${var.domain_name}/"
  token   = var.vault_token
}

terraform {
required_version = ">= 1.0"
  required_providers {
    random = {
      source = "hashicorp/random"
      version = ">= 3.4"
    }
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.48"
    }
    vault = {
      source = "hashicorp/vault"
      version = ">= 3.11"
    }
    boundary = {
      source = "hashicorp/boundary"
      version = ">= 1.1"
    }
  }
}