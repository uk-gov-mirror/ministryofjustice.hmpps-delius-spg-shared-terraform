resource "aws_lb_target_group" "environment" {
  name                 = "${var.appname}-tg"
  port                 = var.target_port
  protocol             = var.target_protocol
  vpc_id               = var.vpc_id
  deregistration_delay = var.deregistration_delay
  target_type          = var.target_type

  dynamic "health_check" {
    for_each = var.health_check
    content {
      interval                = health_check.value.interval
      healthy_threshold       = health_check.value.healthy_threshold
      unhealthy_threshold     = health_check.value.unhealthy_threshold
      protocol                = health_check.value.protocol
      port                    = health_check.value.port
    }
  }


  #stickiness is only valid for ALBs, when NLB is used, it must be explicitly set to false as of 20/03/2019 otherwise terraform trips up
  #see https://github.com/terraform-providers/terraform-provider-aws/issues/2746
  #
  #Unable to pass this as a map as it expects a list (pcrimes)
  stickiness {
        enabled = false
        type = "lb_cookie"
  }

  tags = "${merge(var.tags, map("Name", "${var.appname}-tg"))}"
}
