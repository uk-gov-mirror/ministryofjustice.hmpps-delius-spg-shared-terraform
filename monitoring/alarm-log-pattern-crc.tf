module "crc_exceptions" {
  source                 = "../modules/log_pattern_alarm"
  log_group_name         = "${local.crc_log_group_name}"
  name                   = "crc-log-pattern-exceptions"
  pattern                = "Exception"
  short_environment_name = "${local.short_environment_name}"
  alarm_notification_arn = "${aws_sns_topic.alarm_notification.arn}"
}

module "crc_alerts" {
  source                 = "../modules/log_pattern_alarm"
  log_group_name         = "${local.crc_log_group_name}"
  name                   = "crc-log-pattern-alerts"
  pattern                = "ALERT"
  short_environment_name = "${local.short_environment_name}"
  alarm_notification_arn = "${aws_sns_topic.alarm_notification.arn}"
}

module "crc_504s" {
  source                 = "../modules/log_pattern_alarm"
  log_group_name         = "${local.crc_log_group_name}"
  name                   = "crc-log-pattern-504s"
  pattern                = "\"messageNotificationStatusCode=504\" -\"to=SPG\"" //ignore 504s to SPG
  short_environment_name = "${local.short_environment_name}"
  alarm_notification_arn = "${aws_sns_topic.alarm_notification.arn}"
}
