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
  region                       = "${var.region}"
  spg_app_name                 = "${data.terraform_remote_state.common.spg_app_name}"
  environment_identifier       = "${data.terraform_remote_state.common.environment_identifier}"
  short_environment_identifier = "${data.terraform_remote_state.common.short_environment_identifier}"
  account_id                   = "${data.terraform_remote_state.common.common_account_id}"
  common_name                  = "${var.environment_identifier}-${var.spg_app_name}"

  ####################################################

  #policies
  ec2_internal_policy_file     = "${file("../policies/ec2_internal_policy.json")}"
  ec2_internal_crc_policy_file = "${file("../policies/ec2_internal_crcstub_policy.json")}"
  ec2_external_policy_file     = "${file("../policies/ec2_external_policy.json")}"
  ecs_role_policy_file         = "${file("../policies/ecs_role_policy.json")}"
  #policy files referenced within modules/iam/roles/policy
  ecs_policy_file        = "ecs_policy.json"
  ec2_policy_file        = "ec2_policy.json"
  backups-bucket-name    = "${var.backups-bucket-name}"
  s3-config-bucket       = "${data.terraform_remote_state.common.common_s3-config-bucket}"
  s3-certificates-bucket = "${data.terraform_remote_state.common.common_engineering_certificates_s3_bucket}"
  tags                   = "${merge(var.tags, map("sub-project", "${local.spg_app_name}"))}"
}
