resource "aws_cloudwatch_metric_alarm" "mpx_lb_latency_greater_than_5_seconds" {
  alarm_name          = "${local.short_environment_name}__spgw__mpx-lb-latency__warning"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Latency"
  namespace           = "AWS/ELB"
  period              = "300"
  statistic           = "Average"
  threshold           = "5"
  treat_missing_data  = "notBreaching"
  alarm_description   = "This metric monitors mpx lb Latency"
  alarm_actions       = ["${aws_sns_topic.alarm_notification.arn}"]

  ok_actions = ["${aws_sns_topic.alarm_notification.arn}"]

  dimensions {
    LoadBalancerName = "${local.mpx_lb_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "mpx_lb_spillovercount_greater_than_zero" {
  alarm_name          = "${local.short_environment_name}__spgw__mpx-lb-spill-over-count__warning"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "SpilloverCount"
  namespace           = "AWS/ELB"
  period              = "300"
  statistic           = "Average"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
  alarm_description   = "This metric monitors mpx_lb_spillovercount"
  alarm_actions       = ["${aws_sns_topic.alarm_notification.arn}"]

  ok_actions = ["${aws_sns_topic.alarm_notification.arn}"]

  dimensions {
    LoadBalancerName = "${local.mpx_lb_name}"
  }
}
