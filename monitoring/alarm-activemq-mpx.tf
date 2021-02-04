resource "aws_cloudwatch_metric_alarm" "outbound_delius_queue_size_broker_warning_alarm" {
  count               = 2
  actions_enabled     = var.activemq_alarm_enabled
  alarm_name          = "${local.short_environment_name}__spgw__activemq-broker-${count.index + 1}-outbound-delius-queue-size__warning"
  alarm_description   = "Queue outbound.delius size exceeded 20 for 10 minutes."
  namespace           = "AWS/AmazonMQ"
  statistic           = "Sum"
  metric_name         = "QueueSize"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "20"
  evaluation_periods  = "10"
  period              = "60"

  alarm_actions = [aws_sns_topic.alarm_notification.arn]
  ok_actions    = [aws_sns_topic.alarm_notification.arn]

  dimensions = {
    Queue  = "outbound.delius"
    Broker = "${data.terraform_remote_state.amazonmq.outputs.amazon_mq_broker_name}-${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "outbound_stc_queue_size_broker_warning_alarm" {
  count               = 2
  actions_enabled     = var.activemq_alarm_enabled
  alarm_name          = "${local.short_environment_name}__spgw__activemq-broker-${count.index + 1}-outbound-stc-queue-size__warning"
  alarm_description   = "Queue outbound.crc.STC size exceeded 100 for 10 minutes."
  namespace           = "AWS/AmazonMQ"
  statistic           = "Sum"
  metric_name         = "QueueSize"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "100"
  evaluation_periods  = "10"
  period              = "60"

  alarm_actions = [aws_sns_topic.alarm_notification.arn]
  ok_actions    = [aws_sns_topic.alarm_notification.arn]

  dimensions = {
    Queue  = "outbound.crc.STC"
    Broker = "${data.terraform_remote_state.amazonmq.outputs.amazon_mq_broker_name}-${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "outbound_mtc_queue_size_broker_warning_alarm" {
  count               = 2
  actions_enabled     = var.activemq_alarm_enabled
  alarm_name          = "${local.short_environment_name}__spgw__activemq-broker-${count.index + 1}-outbound-mtc-queue-size__warning"
  alarm_description   = "Queue outbound.crc.MTC size exceeded 200 for 10 minutes."
  namespace           = "AWS/AmazonMQ"
  statistic           = "Sum"
  metric_name         = "QueueSize"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "200"
  evaluation_periods  = "10"
  period              = "60"

  alarm_actions = [aws_sns_topic.alarm_notification.arn]
  ok_actions    = [aws_sns_topic.alarm_notification.arn]

  dimensions = {
    Queue  = "outbound.crc.MTC"
    Broker = "${data.terraform_remote_state.amazonmq.outputs.amazon_mq_broker_name}-${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "outbound_alfresco_queue_size_broker_warning_alarm" {
  count               = 2
  actions_enabled     = var.activemq_alarm_enabled
  alarm_name          = "${local.short_environment_name}__spgw__activemq-broker-${count.index + 1}-outbound-alfresco-queue-size__warning"
  alarm_description   = "Queue outbound.alfresco size exceeded 10 for 10 minutes."
  namespace           = "AWS/AmazonMQ"
  statistic           = "Sum"
  metric_name         = "QueueSize"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "10"
  evaluation_periods  = "10"
  period              = "60"

  alarm_actions = [aws_sns_topic.alarm_notification.arn]
  ok_actions    = [aws_sns_topic.alarm_notification.arn]

  dimensions = {
    Queue  = "outbound.alfresco"
    Broker = "${data.terraform_remote_state.amazonmq.outputs.amazon_mq_broker_name}-${count.index + 1}"
  }
}

