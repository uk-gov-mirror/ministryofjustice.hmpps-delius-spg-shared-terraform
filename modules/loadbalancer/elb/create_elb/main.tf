resource "aws_elb" "environment" {
  name            = var.name
  subnets         = var.subnets
  internal        = var.internal
  security_groups = var.security_groups

  cross_zone_load_balancing   = "${var.cross_zone_load_balancing}"
  idle_timeout                = "${var.idle_timeout}"
  connection_draining         = "${var.connection_draining}"
  connection_draining_timeout = "${var.connection_draining_timeout}"

  dynamic "listener" {
    for_each = var.listener
    content {
      instance_port                = listener.value.instance_port
      instance_protocol            = listener.value.instance_protocol
      lb_port                      = listener.value.lb_port
      lb_protocol                  = listener.value.lb_protocol
    }
  }

  access_logs  {
    bucket        = var.bucket
    bucket_prefix = var.bucket_prefix
    interval      = var.interval
  }

  dynamic "health_check" {
    for_each = var.health_check
    content {
      target                  = health_check.value.target
      interval                = health_check.value.interval
      healthy_threshold       = health_check.value.healthy_threshold
      unhealthy_threshold     = health_check.value.unhealthy_threshold
      timeout                 = health_check.value.timeout
    }
  }

  tags         = "${merge(var.tags, map("Name", format("%s", var.name)))}"

}
