resource "aws_cloudwatch_metric_alarm" "spgw_mpx_servicemix_logs" {
  count = "${var.servicemix_logs_alarm_enabled}"
  alarm_name          = "${local.short_environment_name}__spgw__mpx-servicemix-logs__warning"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "${local.servicemix_log_alarm_evaluation_period}"
  metric_name         = "${local.mpx_metric_name}"
  namespace           = "${local.application}"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data = "breaching"

  alarm_description = <<EOF
 spgw mpx servicemix logs alert triggered, please check if cloudwatch agent is running on the host! Run following command to verify the agent status: systemctl status awslogsd
 EOF


  alarm_actions = [
    "${aws_sns_topic.alarm_notification.arn}",
  ]

  ok_actions = [
    "${aws_sns_topic.alarm_notification.arn}",
  ]
}


resource "aws_cloudwatch_log_metric_filter" "spgw_mpx_servicemix_logs_filter" {
  count = "${var.servicemix_logs_alarm_enabled}"
  name           = "${local.mpx_filter_name}"
  pattern        = "${local.pattern}"
  log_group_name = "${local.mpx_log_group_name}"

  metric_transformation {
    name      = "${local.mpx_metric_name}"
    namespace = "${local.application}"
    value     = "1"
  }
}
