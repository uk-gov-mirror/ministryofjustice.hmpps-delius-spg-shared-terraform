terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 1.16"
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
//  public_cidr_block      = ["${data.terraform_remote_state.common.public_cidr_block}"]
  private_cidr_block     = ["${data.terraform_remote_state.common.private_cidr_block}"]
//  sg_map_ids             = "${data.terraform_remote_state.common.sg_map_ids}"
  weblogic_domain_ports  = "${var.weblogic_domain_ports}"
  spg_partnergateway_domain_ports  = "${var.spg_partnergateway_domain_ports}"

  natgateway_common-nat-public-ip-az1 = "${data.terraform_remote_state.nat.natgateway_common-nat-public-ip-az1}"
  natgateway_common-nat-public-ip-az2 = "${data.terraform_remote_state.nat.natgateway_common-nat-public-ip-az2}"
  natgateway_common-nat-public-ip-az3 = "${data.terraform_remote_state.nat.natgateway_common-nat-public-ip-az3}"

//  amazonmq_inst_sg_id = "${data.terraform_remote_state.common.amazonmq_inst_sg_id}"
//  spg_outbound_id     = "${data.terraform_remote_state.common.spg_common_outbound_sg_id}"


  tags               = "${var.tags}"


}













