data "template_file" "dashboard_loadbalancer_body" {
  template = "${file("dashboard_loadbalancer.json")}"

  vars {
    region           = "${var.region}"
    environment_name = "${local.project_name_abbreviated}"
  }
}

data "template_file" "alert_count_body" {
  template = "${file("dashboard_alert_count.json")}"

  vars {
    region                  = "${var.region}"
    hmpps_asset_name_prefix = "${local.hmpps_asset_name_prefix}"
  }
}

data "template_file" "dashboard_activemq_body" {
  template = "${file("dashboard_activemq_broker.json")}"

  vars {
    region                  = "${var.region}"
    hmpps_asset_name_prefix = "${local.hmpps_asset_name_prefix}"
  }
}



data "template_file" "dashboard_spg_instance_body" {
  template = "${file("dashboard_spg_instance.json")}"

  vars {
    region           = "${var.region}"
    environment_name = "${local.project_name_abbreviated}"
  }
}

resource "aws_cloudwatch_dashboard" "LB_monitoring" {
  dashboard_name = "${local.hmpps_asset_name_prefix}_spgw_lb_monitoring"
  dashboard_body = "${data.template_file.dashboard_loadbalancer_body.rendered}"
}

resource "aws_cloudwatch_dashboard" "alert_count" {
  dashboard_name = "${local.hmpps_asset_name_prefix}_spgw_alert_count"
  dashboard_body = "${data.template_file.alert_count_body.rendered}"
}

resource "aws_cloudwatch_dashboard" "amq_monitoring_broker" {
  dashboard_name = "${local.hmpps_asset_name_prefix}_spgw_activemq_monitoring"
  dashboard_body = "${data.template_file.dashboard_activemq_body.rendered}"
}



resource "aws_cloudwatch_dashboard" "spg_instance_monitoring" {
  dashboard_name = "${local.hmpps_asset_name_prefix}_spgw_instance_monitoring"
  dashboard_body = "${data.template_file.dashboard_spg_instance_body.rendered}"
}
