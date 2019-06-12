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
