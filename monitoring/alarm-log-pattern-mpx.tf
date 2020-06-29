module "mpx_exceptions" {
  source                 = "../modules/log_pattern_alarm"
  log_group_name         = "${local.mpx_log_group_name}"
  name                   = "mpx-log-pattern-exceptions"
  pattern                = "\"Exception\" -\"logAbsorbedMessage\""  #exclude logAbsorbedmessage exceptions as they are expected
  short_environment_name = "${local.short_environment_name}"
  alarm_notification_arn = "${aws_sns_topic.alarm_notification.arn}"
}

module "mpx_alerts" {
  source                 = "../modules/log_pattern_alarm"
  log_group_name         = "${local.mpx_log_group_name}"
  name                   = "mpx-log-pattern-alerts"
  pattern                = "ALERT"
  short_environment_name = "${local.short_environment_name}"
  alarm_notification_arn = "${aws_sns_topic.alarm_notification.arn}"
}

module "mpx_504s" {
  source                 = "../modules/log_pattern_alarm"
  log_group_name         = "${local.mpx_log_group_name}"
  name                   = "mpx-log-pattern-504s"
  pattern                = "\"messageNotificationStatusCode=504\" -\"to=SPG\"" //ignore 504s to SPG
  short_environment_name = "${local.short_environment_name}"
  alarm_notification_arn = "${aws_sns_topic.alarm_notification.arn}"
}

module "mpx_599s" {
  source                 = "../modules/log_pattern_alarm"
  log_group_name         = "${local.mpx_log_group_name}"
  name                   = "mpx-log-pattern-599s"
  pattern                = "\"messageNotificationStatusCode=599\""
  short_environment_name = "${local.short_environment_name}"
  alarm_notification_arn = "${aws_sns_topic.alarm_notification.arn}"
}

module "mpx_601s" {
  source                 = "../modules/log_pattern_alarm"
  log_group_name         = "${local.mpx_log_group_name}"
  name                   = "mpx-log-pattern-601s"
  pattern                = "\"messageNotificationStatusCode=601\""
  short_environment_name = "${local.short_environment_name}"
  alarm_notification_arn = "${aws_sns_topic.alarm_notification.arn}"
}
