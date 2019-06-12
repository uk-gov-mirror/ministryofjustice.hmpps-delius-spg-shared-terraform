

data "template_file" "dashboard_body" {
  template = "${file("dashboard.json")}"
  vars {
    region            = "${var.region}"
    environment_name  = "${local.project_name_abbreviated}"
  }
}

resource "aws_cloudwatch_dashboard" "LB_monitoring" {
  dashboard_name = "${local.spg_app_name}_lb_monitoring"
  dashboard_body = "${data.template_file.dashboard_body.rendered}"
}
