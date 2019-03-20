terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 1.16"
}

####################################################
# DATA SOURCE MODULES FROM OTHER TERRAFORM BACKENDS
####################################################

#-------------------------------------------------------------
### Getting the common details
#-------------------------------------------------------------
data "terraform_remote_state" "common" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "spg/common/terraform.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "vpc/terraform.tfstate"
    region = "${var.region}"
  }
}

####################################################
# Locals
####################################################

locals {
  internal_domain        = "${data.terraform_remote_state.common.internal_domain}"
  external_domain        = "${data.terraform_remote_state.vpc.public_zone_name}"
  common_name            = "${data.terraform_remote_state.common.common_name}"   #common name for APP not common name for DNS
  region                 = "${var.region}"
  spg_app_name           = "${var.spg_app_name}"
  environment_identifier = "${var.environment_identifier}"
  environment            = "${var.environment_type}"
  tags                   = "${merge(data.terraform_remote_state.vpc.tags, map("sub-project", "${var.spg_app_name}"))}"
}



####################################################
# Self Signed CA
####################################################
module "self_signed_ca" {
  source                               = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//projects//alfresco//self-signed//ca"
  is_ca_certificate                    = true
  internal_domain                      = "${local.}"
  region                               = "${local.region}"
  tags                                 = "${local.tags}"
  common_name                          = "${local.common_name}"
  self_signed_ca_rsa_bits              = "${var.self_signed_ca_rsa_bits}"
  self_signed_ca_algorithm             = "${var.self_signed_ca_algorithm}"
  self_signed_ca_validity_period_hours = "${var.self_signed_ca_validity_period_hours}"
  self_signed_ca_early_renewal_hours   = "${var.self_signed_ca_early_renewal_hours}"
  alfresco_app_name                    = "${local.spg_app_name}"
  environment_identifier               = "${local.environment_identifier}"
}

####################################################
# Self Signed Cert
####################################################
module "self_signed_cert" {
  source                                   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//projects//alfresco//self-signed//server"
  alfresco_app_name                        = "${local.spg_app_name}"
  ca_cert_pem                              = "${module.self_signed_ca.self_signed_ca_cert_pem}"
  ca_private_key_pem                       = "${module.self_signed_ca.self_signed_ca_private_key}"
  common_name                              = "${local.common_name}"
  environment_identifier                   = "${local.environment_identifier}"
  internal_domain                          = "${local.internal_domain}"
  region                                   = "${local.region}"
  self_signed_server_algorithm             = "${var.self_signed_server_algorithm}"
  self_signed_server_validity_period_hours = "${var.self_signed_server_validity_period_hours}"
  self_signed_server_rsa_bits              = "${var.self_signed_server_rsa_bits}"
  self_signed_server_early_renewal_hours   = "${var.self_signed_server_early_renewal_hours}"
  tags                                     = "${local.tags}"

  depends_on = [
    "${module.self_signed_ca.self_signed_ca_cert_pem}",
    "${module.self_signed_ca.self_signed_ca_private_key}",
  ]
}
