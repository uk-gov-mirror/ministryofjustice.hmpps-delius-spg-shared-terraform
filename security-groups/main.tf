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
  vpc_id                 = "${data.terraform_remote_state.common.vpc_id}"
  cidr_block             = "${data.terraform_remote_state.common.vpc_cidr_block}"
  allowed_cidr_block     = ["${var.allowed_cidr_block}"]
  common_name            = "${data.terraform_remote_state.common.environment_identifier}"
  region                 = "${data.terraform_remote_state.common.region}"
  spg_app_name           = "${data.terraform_remote_state.common.spg_app_name}"
  environment_identifier = "${data.terraform_remote_state.common.environment_identifier}"
  #environment            = "${data.terraform_remote_state.common.environment}"
  #tags                   = "${data.terraform_remote_state.common.common_tags}"
  public_cidr_block      = ["${data.terraform_remote_state.common.db_cidr_block}"]
  private_cidr_block     = ["${data.terraform_remote_state.common.private_cidr_block}"]
  db_cidr_block          = ["${data.terraform_remote_state.common.db_cidr_block}"]
  sg_map_ids             = "${data.terraform_remote_state.common.sg_map_ids}"
  weblogic_domain_ports  = "${var.weblogic_domain_ports}"
  spg_partnergateway_domain_ports  = "${var.spg_partnergateway_domain_ports}"

}

####################################################
# Security Groups - Application Specific
####################################################
module "security_groups" {
  source                 = "../modules/security-groups"
  spg_app_name           = "${local.spg_app_name}"
  allowed_cidr_block     = ["${local.allowed_cidr_block}"]
  common_name            = "${local.common_name}"
  environment_identifier = "${local.environment_identifier}"
  region                 = "${local.region}"
  tags                   = "${var.tags}"
  vpc_id                 = "${local.vpc_id}"
  public_cidr_block      = ["${local.public_cidr_block}"]
  private_cidr_block     = ["${local.private_cidr_block}"]
  db_cidr_block          = ["${local.db_cidr_block}"]
  sg_map_ids             = "${local.sg_map_ids}"
  alb_http_port          = "80"
  alb_https_port         = "9001"
  alb_backend_port       = "8181"
  weblogic_domain_ports  = "${local.weblogic_domain_ports}"
  spg_partnergateway_domain_ports  = "${local.spg_partnergateway_domain_ports}"
}
