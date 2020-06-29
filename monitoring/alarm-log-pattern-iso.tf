module "iso_exceptions" {
  source                 = "../modules/log_pattern_alarm"
  log_group_name         = "${local.iso_log_group_name}"
  name                   = "iso-log-pattern-exceptions"
  pattern                = "\"Exception\" -\"with statusCode\"" #exclude error responses from alfresco which are wrapped by exception handler
  short_environment_name = "${local.short_environment_name}"
  alarm_notification_arn = "${aws_sns_topic.alarm_notification.arn}"
}

module "iso_alerts" {
  source                 = "../modules/log_pattern_alarm"
  log_group_name         = "${local.iso_log_group_name}"
  name                   = "iso-log-pattern-alerts"
  pattern                = "ALERT"
  short_environment_name = "${local.short_environment_name}"
  alarm_notification_arn = "${aws_sns_topic.alarm_notification.arn}"
}

module "iso_504s" {
  source                 = "../modules/log_pattern_alarm"
  log_group_name         = "${local.iso_log_group_name}"
  name                   = "iso-log-pattern-504s"
  pattern                = "\"messageNotificationStatusCode=504\" -\"to=SPG\"" //ignore 504s to SPG
  short_environment_name = "${local.short_environment_name}"
  alarm_notification_arn = "${aws_sns_topic.alarm_notification.arn}"
}

module "iso_601s" {
  source                 = "../modules/log_pattern_alarm"
  log_group_name         = "${local.iso_log_group_name}"
  name                   = "iso-log-pattern-601s"
  pattern                = "\"messageNotificationStatusCode=601\""
  short_environment_name = "${local.short_environment_name}"
  alarm_notification_arn = "${aws_sns_topic.alarm_notification.arn}"
}
