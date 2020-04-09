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
  #workaround for training-test exceeding 64 chars
  dynamic_environment_identifier = "${(local.environment_identifier == "tf-eu-west-2-hmpps-delius-training-test") ? local.short_environment_identifier : local.environment_identifier}"
  common_name                  = "${local.dynamic_environment_identifier}-${var.spg_app_name}"

  ####################################################

  #policies
  ec2_iam_module_default_assume_role_policy_file = "ec2_policy.json"
  ec2_internal_mpx_policy_file                   = "../policies/ec2_mpx_internal_policy.json"
  ec2_internal_crc_policy_file                   = "../policies/ec2_crc_internal_policy.json"
  ec2_external_iso_policy_file                   = "../policies/ec2_iso_external_policy.json"
  ecs_module_default_assume_role_policy_file     = "ecs_policy.json"
  ecs_role_policy_file                           = "../policies/ecs_role_policy.json"
  backups-bucket-name                            = "${var.backups-bucket-name}"
  s3-certificates-bucket                         = "${data.terraform_remote_state.common.common_engineering_certificates_s3_bucket}"
  tags                                           = "${merge(var.tags, map("sub-project", "${local.spg_app_name}"))}"
}
