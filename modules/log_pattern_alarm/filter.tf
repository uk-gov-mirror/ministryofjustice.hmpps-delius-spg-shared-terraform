resource "aws_cloudwatch_log_metric_filter" "filter" {
  name           = "${local.filter_name}"
  pattern        = "${local.pattern}"
  log_group_name = "${local.log_group_name}"

  metric_transformation {
    name      = "${local.metric_name}"
    namespace = "${local.application}"
    value     = "1"
  }
}
