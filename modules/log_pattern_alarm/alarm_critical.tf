resource "aws_cloudwatch_metric_alarm" "critical" {
  alarm_name = "${local.alarm_name_prefix}__critical"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "6"
  metric_name         = "${local.metric_name}"
  namespace           = "${local.application}"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  datapoints_to_alarm = "6"
  treat_missing_data  = "notBreaching"

  alarm_description = <<EOF
Exception encountered in application log <https://eu-west-2.console.aws.amazon.com/cloudwatch/home?region=eu-west-2#logEventViewer:group=${local.log_group_name};filter=Exception|${local.log_group_name}>

For alarm / metric: <https://eu-west-2.console.aws.amazon.com/cloudwatch/home?region=eu-west-2#alarmsV2:alarm/${local.alarm_name_prefix}__critical|${local.alarm_name_prefix}__critical>
EOF

  alarm_actions = [
    "${local.alarm_nortication_arn}",
  ]

  ok_actions = [
    "${local.alarm_nortication_arn}",
  ]
}
