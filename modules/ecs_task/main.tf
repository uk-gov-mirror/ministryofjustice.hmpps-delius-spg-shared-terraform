resource "aws_ecs_task_definition" "environment" {
  family = "${var.hmpps_asset_name_prefix}-${var.app_name}-task-definition"
  container_definitions = var.container_definitions
  execution_role_arn = var.execution_role_arn

  volume {
    name = "amqbroker"
    host_path = "/opt/spg/servicemix/amq-broker"
  }


  volume {
    name = "log"
    host_path = "/var/log/${var.container_name}"
  }

  volume {
    name = "${var.data_volume_name}"
    host_path = "${var.data_volume_host_path}"
  }
}
