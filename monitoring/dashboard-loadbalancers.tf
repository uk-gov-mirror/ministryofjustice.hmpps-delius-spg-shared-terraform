

data "template_file" "dashboard_body" {
  template = "${file("dashboard.json")}"
  vars {
    region            = "${var.region}"
//    asg_name          = "${data.terraform_remote_state.application.asg_name}"
//    elb_name          = "${data.terraform_remote_state.application.elb_name}"
    environment_name  = "${local.project_name_abbreviated}"
//    db_name           = "${local.db_name}"
//    db_cpu_alarm      = "${local.db_cpu_alarm}"
//    db_storage        = "${var.db_storage * 1200000000}"
//    db_storage_alarm  = "${local.db_storage_alarm * 1000000000}"
//    db_memory         = "${var.db_memory * 1000000}"
//    db_memory_alarm   = "${local.db_memory_alarm * 1000000}"
//    eb_asg_scale-up   = "${var.upper_cpu_trigger}"
//    eb_asg_scale-down = "${var.lower_cpu_trigger}"
//    slow_latency      = 1
//    redis_cpu_alarm   = "${local.redis_cpu_alarm}"
//    redis_swap_alarm  = "${local.redis_swap_alarm}"
  }
}

resource "aws_cloudwatch_dashboard" "LB_monitoring" {
  dashboard_name = "${local.spg_app_name}_lb_monitoring"
  dashboard_body = "${data.template_file.dashboard_body.rendered}"
}
