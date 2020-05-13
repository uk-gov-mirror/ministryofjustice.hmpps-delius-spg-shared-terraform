resource "aws_cloudwatch_metric_alarm" "warning" {
  alarm_name = "${local.alarm_name_prefix}__warning"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "${local.metric_name}"
  namespace           = "${local.application}"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data = "notBreaching"

  alarm_description = <<EOF
${local.name} alert triggered in application log <https://eu-west-2.console.aws.amazon.com/cloudwatch/home?region=eu-west-2#logEventViewer:group=${local.log_group_name};filter=${urlencode(local.pattern)};${local.date_range_placeholder}|${local.log_group_name}>

For alarm / metric: <https://eu-west-2.console.aws.amazon.com/cloudwatch/home?region=eu-west-2#alarmsV2:alarm/${local.alarm_name_prefix}__warning|${local.alarm_name_prefix}__warning>
EOF

  alarm_actions = [
    "${local.alarm_notification_arn}",
  ]

  ok_actions = [
    "${local.alarm_notification_arn}",
  ]
}
