resource "aws_sns_topic" "alarm_notification" {
  name = "${local.short_environment_name}-${local.spg_app_name}-alarm-notification"
}

resource "aws_sns_topic_subscription" "alarm_subscription" {
  topic_arn = "${aws_sns_topic.alarm_notification.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.notify-slack.arn}"
}
