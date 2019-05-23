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
//not got time to reafctor for external domain
//  internal_domain        = "${data.terraform_remote_state.common.internal_domain}"
  internal_domain        = "${data.terraform_remote_state.vpc.public_zone_name}"

  external_domain        = "${data.terraform_remote_state.vpc.public_zone_name}"
  common_name            = "${data.terraform_remote_state.common.common_name}"   #common name for APP not common name for DNS
  region                 = "${var.region}"
  spg_app_name           = "${var.spg_app_name}"
  environment_identifier = "${var.environment_identifier}"
  environment            = "${var.environment_type}"
  tags                   = "${merge(data.terraform_remote_state.vpc.tags, map("sub-project", "${var.spg_app_name}"))}"
}



