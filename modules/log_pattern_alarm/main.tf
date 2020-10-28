locals {
  application = "spgw"
  log_group_name = var.log_group_name
  pattern = var.pattern
  name = var.name

  alarm_notification_arn = var.alarm_notification_arn

  filter_name = "${var.short_environment_name}-${local.name}-filter"
  metric_name = "${var.short_environment_name}-${local.name}-count"

  alarm_name_prefix = "${var.short_environment_name}__${local.application}__${local.name}"
  date_range_placeholder = "start_end_date_placeholder"
}