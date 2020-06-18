terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
  required_version = "~> 0.11"
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 2.45.0"
}

# Shared data and constants

locals {
  tags                     = "${merge(var.tags, map("Build", "${var.build_tag}"))}"
  short_environment_name   = "${data.terraform_remote_state.common.short_environment_name}"
  app_hostnames            = "${data.terraform_remote_state.common.app_hostnames}"
  hmpps_asset_name_prefix  = "${data.terraform_remote_state.common.hmpps_asset_name_prefix}"
  project_name_abbreviated = "${data.terraform_remote_state.common.project_name_abbreviated}"
  spg_app_name             = "${data.terraform_remote_state.common.spg_app_name}"
  lambda_name              = "spgw_alarm_slack_notification"
  application = "spgw"
  pattern = ""

  filter_name = "${local.short_environment_name}--cloudwatch-agent__filter"
  metric_name = "${local.short_environment_name}--cloudwatch-agent-count"

  mpx_lb_name = "${data.terraform_remote_state.ecs_mpx.environment_elb_name}"

  iso_lb_arn_suffix              = "${data.terraform_remote_state.ecs_iso.lb_arn_suffix}"
  iso_lb_target_group_arn_suffix = "${data.terraform_remote_state.ecs_iso.target_group_arn_suffix}"

  crc_log_group_name = "${data.terraform_remote_state.ecs_crc.ecs_spg_loggroup_name}"
  iso_log_group_name = "${data.terraform_remote_state.ecs_iso.loggroup_name}"
  mpx_log_group_name = "${data.terraform_remote_state.ecs_mpx.ecs_spg_loggroup_name}"

}