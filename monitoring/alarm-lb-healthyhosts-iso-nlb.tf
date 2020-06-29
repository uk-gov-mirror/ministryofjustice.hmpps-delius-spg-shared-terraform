resource "aws_cloudwatch_metric_alarm" "iso_lb_unhealthy_hosts_greater_than_zero_for_5_mins" {
  alarm_name          = "${local.short_environment_name}__spgw__iso-nlb-unhealthy__warning"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/NetworkELB"
  period              = "300"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "Some hosts are unhealthy"
  alarm_actions       = ["${aws_sns_topic.alarm_notification.arn}"]

  ok_actions = ["${aws_sns_topic.alarm_notification.arn}"]

  dimensions {
    TargetGroup  = "${local.iso_lb_target_group_arn_suffix}"
    LoadBalancer = "${local.iso_lb_arn_suffix}"
  }
}

resource "aws_cloudwatch_metric_alarm" "iso_lb_unhealthy_hosts_at_least_one_for_30_mins_critical" {
  alarm_name          = "${local.short_environment_name}__spgw__iso-nlb-unhealthy__critical"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "6"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/NetworkELB"
  period              = "300"
  statistic           = "Sum"
  threshold           = "6"
  alarm_description   = "Some hosts have been unhealthy for half an hour"
  alarm_actions       = ["${aws_sns_topic.alarm_notification.arn}"]

  ok_actions = ["${aws_sns_topic.alarm_notification.arn}"]

  dimensions {
    TargetGroup  = "${local.iso_lb_target_group_arn_suffix}"
    LoadBalancer = "${local.iso_lb_arn_suffix}"
  }
}

resource "aws_cloudwatch_metric_alarm" "iso_lb_healthy_hosts_less_than_one" {
  alarm_name          = "${local.short_environment_name}__spgw__iso-nlb-healthy__fatal"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/NetworkELB"
  period              = "300"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "No Healthy Hosts!!!"
  alarm_actions       = ["${aws_sns_topic.alarm_notification.arn}"]

  ok_actions = ["${aws_sns_topic.alarm_notification.arn}"]

  dimensions {
    TargetGroup  = "${local.iso_lb_target_group_arn_suffix}"
    LoadBalancer = "${local.iso_lb_arn_suffix}"
  }
}
