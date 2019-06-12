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


### Getting the vpc details
#-------------------------------------------------------------
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
  vpc_id                 = "${data.terraform_remote_state.common.vpc_id}"
  cidr_block             = "${data.terraform_remote_state.common.vpc_cidr_block}"
  allowed_cidr_block     = ["${var.allowed_cidr_block}"]
  region                 = "${data.terraform_remote_state.common.region}"
  environment_identifier = "${data.terraform_remote_state.common.environment_identifier}"
  short_environment_name = "${data.terraform_remote_state.common.short_environment_name}"
  spg_app_name           = "${data.terraform_remote_state.common.spg_app_name}"
  common_name            = "${local.short_environment_name}-${local.spg_app_name}"
  public_cidr_block      = ["${data.terraform_remote_state.common.db_cidr_block}"]
  private_cidr_block     = ["${data.terraform_remote_state.common.private_cidr_block}"]
  sg_map_ids             = "${data.terraform_remote_state.common.sg_map_ids}"
  weblogic_domain_ports  = "${var.weblogic_domain_ports}"
  spg_partnergateway_domain_ports  = "${var.spg_partnergateway_domain_ports}"


  tags               = "${var.tags}"

  internal_lb_sg_id   = "${local.sg_map_ids["internal_lb_sg_id"]}"
  internal_inst_sg_id = "${local.sg_map_ids["internal_inst_sg_id"]}"
  external_lb_sg_id   = "${local.sg_map_ids["external_lb_sg_id"]}"
  external_inst_sg_id = "${local.sg_map_ids["external_inst_sg_id"]}"

}
