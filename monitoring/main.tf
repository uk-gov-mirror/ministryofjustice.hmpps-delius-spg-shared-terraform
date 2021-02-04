locals {
  tags = merge(
    var.tags,
    {
      "Build" = var.build_tag
    },
  )
  short_environment_name                 = data.terraform_remote_state.common.outputs.short_environment_name
  app_hostnames                          = data.terraform_remote_state.common.outputs.app_hostnames
  hmpps_asset_name_prefix                = data.terraform_remote_state.common.outputs.hmpps_asset_name_prefix
  project_name_abbreviated               = data.terraform_remote_state.common.outputs.project_name_abbreviated
  spg_app_name                           = data.terraform_remote_state.common.outputs.spg_app_name
  lambda_name                            = "spgw_alarm_slack_notification"
  application                            = "spgw"
  pattern                                = ""
  servicemix_log_alarm_evaluation_period = var.servicemix_log_alarm_evaluation_period

  mpx_filter_name = "${local.short_environment_name}--mpx-cloudwatch-agent__filter"
  mpx_metric_name = "${local.short_environment_name}--mpx-cloudwatch-agent-count"

  iso_filter_name = "${local.short_environment_name}--iso-cloudwatch-agent__filter"
  iso_metric_name = "${local.short_environment_name}--iso-cloudwatch-agent-count"

  mpx_lb_name = data.terraform_remote_state.ecs_mpx.outputs.environment_elb_name

  iso_lb_arn_suffix              = data.terraform_remote_state.ecs_iso.outputs.lb_arn_suffix
  iso_lb_target_group_arn_suffix = data.terraform_remote_state.ecs_iso.outputs.target_group_arn_suffix

  crc_log_group_name = data.terraform_remote_state.ecs_crc.outputs.ecs_spg_application_loggroup_name
  iso_log_group_name = data.terraform_remote_state.ecs_iso.outputs.ecs_spg_application_loggroup_name
  mpx_log_group_name = data.terraform_remote_state.ecs_mpx.outputs.ecs_spg_application_loggroup_name
}

