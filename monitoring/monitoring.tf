data "terraform_remote_state" "application" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "application/terraform.tfstate"
    region = "${var.region}"
  }
}

data "template_file" "dashboard_body" {
  template = "${file("dashboard.json")}"
  vars {
    region            = "${var.region}"
    asg_name          = "${data.terraform_remote_state.application.asg_name}"
    elb_name          = "${data.terraform_remote_state.application.elb_name}"
    environment_name  = "${local.environment_name}"
    db_name           = "${local.db_name}"
    db_cpu_alarm      = "${local.db_cpu_alarm}"
    db_storage        = "${var.db_storage * 1200000000}"
    db_storage_alarm  = "${local.db_storage_alarm * 1000000000}"
    db_memory         = "${var.db_memory * 1000000}"
    db_memory_alarm   = "${local.db_memory_alarm * 1000000}"
    eb_asg_scale-up   = "${var.upper_cpu_trigger}"
    eb_asg_scale-down = "${var.lower_cpu_trigger}"
    slow_latency      = 1
    redis_cpu_alarm   = "${local.redis_cpu_alarm}"
    redis_swap_alarm  = "${local.redis_swap_alarm}"
  }
}

resource "aws_cloudwatch_dashboard" "monitoring" {
  dashboard_name = "${local.environment_name}_monitoring"
  dashboard_body = "${data.template_file.dashboard_body.rendered}"
}


data "template_file" "dashboard_body_draft" {
  template = "${file("draft.dashboard.json")}"
  vars {
    region            = "${var.region}"
    asg_name          = "${data.terraform_remote_state.application.asg_name}"
    elb_name          = "${data.terraform_remote_state.application.elb_name}"
    environment_name  = "${local.environment_name}"
    db_name           = "${local.db_name}"
    db_cpu_alarm      = "${local.db_cpu_alarm}"
    db_storage        = "${var.db_storage * 1200000000}"
    db_storage_alarm  = "${local.db_storage_alarm * 1000000000}"
    db_memory         = "${var.db_memory * 1000000}"
    db_memory_alarm   = "${local.db_memory_alarm * 1000000}"
    eb_asg_scale-up   = "${var.upper_cpu_trigger}"
    eb_asg_scale-down = "${var.lower_cpu_trigger}"
    slow_latency      = 1
    redis_cpu_alarm   = "${local.redis_cpu_alarm}"
    redis_swap_alarm  = "${local.redis_swap_alarm}"
  }
}

resource "aws_cloudwatch_dashboard" "monitoring_draft" {
  dashboard_name = "${local.environment_name}_monitoring_draft"
  dashboard_body = "${data.template_file.dashboard_body_draft.rendered}"
}
