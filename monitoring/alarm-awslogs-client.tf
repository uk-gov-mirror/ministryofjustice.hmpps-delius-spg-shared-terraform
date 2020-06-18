resource "aws_cloudwatch_metric_alarm" "spgw_mpx_cloudwatch_agent" {
  count = "${var.cloudwatch_agent_alarm_enabled}"
  alarm_name          = "${local.short_environment_name}__spgw__mpx-cloudwatch-agent__warning"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "5"
  metric_name         = "${local.metric_name}"
  namespace           = "${local.application}"
  period              = "60" //TODO: Change period
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data = "notBreaching"

  alarm_description = <<EOF
      Spgw mpx cloudwatch agent alert triggered, please check if cloudwatch agent is running on the host.
      Run following command to verify agent status: systemctl status awslogsd
 EOF


  alarm_actions = [
    "${aws_sns_topic.alarm_notification.arn}",
  ]

  ok_actions = [
    "${aws_sns_topic.alarm_notification.arn}",
  ]
}


resource "aws_cloudwatch_log_metric_filter" "spgw_mpx_cloudwatch_agent_filter" {
  count = "${var.cloudwatch_agent_alarm_enabled}"
  name           = "${local.filter_name}"
  pattern        = "${local.pattern}"
  log_group_name = "${local.mpx_log_group_name}"

  metric_transformation {
    name      = "${local.metric_name}"
    namespace = "${local.application}"
    value     = "1"
  }
}
