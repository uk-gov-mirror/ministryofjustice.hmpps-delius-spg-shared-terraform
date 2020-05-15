module "iso_504s" {
  source                 = "../modules/log_pattern_alarm"
  log_group_name         = "${local.iso_log_group_name}"
  name                   = "iso-log-connection-pattern-504s"
  pattern                = "messageNotificationStatusCode=504-to=SPG" //ignore 504s to SPG
  short_environment_name = "${local.short_environment_name}"
  alarm_notification_arn = "${aws_sns_topic.alarm_notification.arn}"
}

module "iso_601s" {
  source                 = "../modules/log_pattern_alarm"
  log_group_name         = "${local.iso_log_group_name}"
  name                   = "iso-log-pattern-601s"
  pattern                = "messageNotificationStatusCode=601"
  short_environment_name = "${local.short_environment_name}"
  alarm_notification_arn = "${aws_sns_topic.alarm_notification.arn}"
}

module "iso_http_5xx" {
  source                 = "../modules/log_pattern_alarm"
  log_group_name         = "${local.iso_log_group_name}"
  name                   = "iso-log-pattern-connection-http-5xx"
  pattern                = "\"with statusCode: 5\""
  short_environment_name = "${local.short_environment_name}"
  alarm_notification_arn = "${aws_sns_topic.alarm_notification.arn}"
}
