module "mpx_504s" {
  source                 = "../modules/log_pattern_alarm"
  log_group_name         = "${local.mpx_log_group_name}"
  name                   = "mpx-log-connection-pattern-504s"
  pattern                = "messageNotificationStatusCode=504-to=SPG" //ignore 504s to SPG
  short_environment_name = "${local.short_environment_name}"
  alarm_notification_arn = "${aws_sns_topic.alarm_notification.arn}"
}

module "mpx_599s" {
  source                 = "../modules/log_pattern_alarm"
  log_group_name         = "${local.mpx_log_group_name}"
  name                   = "mpx-log-pattern-599s"
  pattern                = "messageNotificationStatusCode=599"
  short_environment_name = "${local.short_environment_name}"
  alarm_notification_arn = "${aws_sns_topic.alarm_notification.arn}"
}

module "mpx_601s" {
  source                 = "../modules/log_pattern_alarm"
  log_group_name         = "${local.mpx_log_group_name}"
  name                   = "mpx-log-pattern-601s"
  pattern                = "messageNotificationStatusCode=601"
  short_environment_name = "${local.short_environment_name}"
  alarm_notification_arn = "${aws_sns_topic.alarm_notification.arn}"
}

module "mpx_http_5xx" {
  source                 = "../modules/log_pattern_alarm"
  log_group_name         = "${local.mpx_log_group_name}"
  name                   = "mpx-log-pattern-connection-http-5xx"
  pattern                = "\"with statusCode: 5\""
  short_environment_name = "${local.short_environment_name}"
  alarm_notification_arn = "${aws_sns_topic.alarm_notification.arn}"
}

