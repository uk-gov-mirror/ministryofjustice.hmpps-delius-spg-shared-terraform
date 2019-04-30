### Alarms

resource "aws_cloudwatch_metric_alarm" "environment_severe" {
  alarm_name                = "${local.project_name_abbreviated} environment health severe"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "EnvironmentHealth"
  namespace                 = "AWS/ElasticBeanstalk"
  dimensions                = {
                                EnvironmentName = "${local.project_name_abbreviated}"
                              }
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = "25"
  alarm_description         = "The ${local.project_name_abbreviated} environment is Warning or higher"
  alarm_actions             = ["${aws_sns_topic.alarm_notification.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "environment_warning" {
  alarm_name                = "${local.project_name_abbreviated} environment health warning"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "10"
  metric_name               = "EnvironmentHealth"
  namespace                 = "AWS/ElasticBeanstalk"
  dimensions                = {
    EnvironmentName = "${local.project_name_abbreviated}"
  }
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = "15"
  alarm_description         = "The ${local.project_name_abbreviated} environment is Warning or higher"
  alarm_actions             = ["${aws_sns_topic.alarm_notification.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "latency" {
  alarm_name                = "${local.project_name_abbreviated} environment performance"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "ApplicationLatencyP90"
  namespace                 = "AWS/ElasticBeanstalk"
  dimensions                = {
    EnvironmentName = "${local.project_name_abbreviated}"
  }
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "The response latency for the ${local.project_name_abbreviated} environment is over 1s"
  alarm_actions             = ["${aws_sns_topic.alarm_notification.arn}"]
}

//resource "aws_cloudwatch_metric_alarm" "db_cpu" {
//  alarm_name                = "${local.db_name} DB CPU"
//  comparison_operator       = "GreaterThanThreshold"
//  evaluation_periods        = "2"
//  metric_name               = "CPUUtilization"
//  namespace                 = "AWS/RDS"
//  dimensions                = {
//    DBInstanceIdentifier = "${local.db_name}"
//  }
//  period                    = "60"
//  statistic                 = "Average"
//  threshold                 = "${local.db_cpu_alarm}"
//  alarm_description         = "The CPU utilization for the ${local.db_name} database is over ${local.db_cpu_alarm}%"
//  alarm_actions             = ["${aws_sns_topic.alarm_notification.arn}"]
//}
//
//resource "aws_cloudwatch_metric_alarm" "db_storage" {
//  alarm_name                = "${local.db_name} DB Storage"
//  comparison_operator       = "LessThanThreshold"
//  evaluation_periods        = "2"
//  metric_name               = "FreeStorageSpace"
//  namespace                 = "AWS/RDS"
//  dimensions                = {
//    DBInstanceIdentifier = "${local.db_name}"
//  }
//  period                    = "60"
//  statistic                 = "Average"
//  threshold                 = "${local.db_storage_alarm * 1000000000}"
//  alarm_description         = "The ${local.db_name} database has less than ${local.db_storage_alarm}GB of storage remaining"
//  alarm_actions             = ["${aws_sns_topic.alarm_notification.arn}"]
//}
//
//resource "aws_cloudwatch_metric_alarm" "db_memory" {
//  alarm_name                = "${local.db_name} DB Memory"
//  comparison_operator       = "LessThanThreshold"
//  evaluation_periods        = "2"
//  metric_name               = "FreeableMemory"
//  namespace                 = "AWS/RDS"
//  dimensions                = {
//    DBInstanceIdentifier = "${local.db_name}"
//  }
//  period                    = "60"
//  statistic                 = "Average"
//  threshold                 = "${local.db_memory_alarm * 1000000}"
//  alarm_description         = "The ${local.db_name} database has less than ${local.db_memory_alarm}MB of memory remaining"
//  alarm_actions             = ["${aws_sns_topic.alarm_notification.arn}"]
//}
//
//resource "aws_cloudwatch_metric_alarm" "redis_cpu" {
//  alarm_name                = "Redis CPU"
//  comparison_operator       = "GreaterThanThreshold"
//  evaluation_periods        = "2"
//  metric_name               = "CPUUtilization"
//  namespace                 = "AWS/ElastiCache"
//  period                    = "60"
//  statistic                 = "Average"
//  threshold                 = "${local.redis_cpu_alarm}"
//  alarm_description         = "The redis cluster CPU utilization exceeds ${local.redis_cpu_alarm}%"
//  alarm_actions             = ["${aws_sns_topic.alarm_notification.arn}"]
//}
//
//resource "aws_cloudwatch_metric_alarm" "redis_swap" {
//  alarm_name                = "Redis Swap Usage"
//  comparison_operator       = "GreaterThanThreshold"
//  evaluation_periods        = "2"
//  metric_name               = "SwapUsage"
//  namespace                 = "AWS/ElastiCache"
//  period                    = "60"
//  statistic                 = "Average"
//  threshold                 = "${local.redis_swap_alarm}"
//  alarm_description         = "The redis cluster swap usage exceeds ${local.redis_swap_alarm}"
//  alarm_actions             = ["${aws_sns_topic.alarm_notification.arn}"]
//}
//
### SNS

resource "aws_sns_topic" "alarm_notification" {
  name               = "${local.project_name_abbreviated}_alarm_notification"
}

resource "aws_sns_topic_subscription" "alarm_subscription" {
  count              = "${var.alarms_enabled == "true" ? 1 : 0}"
  topic_arn          = "${aws_sns_topic.alarm_notification.arn}"
  protocol           = "lambda"
  endpoint           = "${aws_lambda_function.notify_ops_with_slack.arn}"
}

### Lambda

locals {
  lambda_name = "notify_ops_with_slack"
}

data "archive_file" "notify_ops_with_slack" {
  type               = "zip"
  source_file        = "${path.module}/lambda/${local.lambda_name}.js"
  output_path        = "${path.module}/files/${local.lambda_name}.zip"
}

data "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
}

resource "aws_lambda_function" "notify_ops_with_slack" {
  filename           = "${data.archive_file.notify_ops_with_slack.output_path}"
  function_name      = "${local.lambda_name}"
  role               = "${data.aws_iam_role.lambda_exec_role.arn}"
  handler            = "${local.lambda_name}.handler"
  source_code_hash   = "${base64sha256(file("${data.archive_file.notify_ops_with_slack.output_path}"))}"
  runtime            = "nodejs8.10"
}

resource "aws_lambda_permission" "with_sns" {
  statement_id        = "AllowExecutionFromSNS"
  action              = "lambda:InvokeFunction"
  function_name       = "${aws_lambda_function.notify_ops_with_slack.arn}"
  principal           = "sns.amazonaws.com"
  source_arn          = "${aws_sns_topic.alarm_notification.arn}"
}
