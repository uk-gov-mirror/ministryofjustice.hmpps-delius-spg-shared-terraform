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

####################################################
# Locals
####################################################

locals {
  region                 = "${var.region}"
  spg_app_name           = "${data.terraform_remote_state.common.spg_app_name}"
  environment_identifier = "${data.terraform_remote_state.common.environment_identifier}"
  tags                   = "${data.terraform_remote_state.common.common_tags}"
}

####################################################
# S3 bucket - Application Specific
####################################################
module "s3bucket" {
  source                 = "../modules/s3bucket"
  spg_app_name           = "${local.spg_app_name}"
  environment_identifier = "${local.environment_identifier}"
  tags                   = "${local.tags}"
}
