
############################################
# CREATE INTERNAL LB FOR spg (crc)
############################################


module "create_app_elb" {
  #  source          = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//loadbalancer//elb//create_elb"
  # requires provider 2.1.6
  source          = "../modules/loadbalancer/elb/create_elb"
  name            = "${local.common_name}-elb"
  subnets         = ["${local.private_subnet_ids}"]
  security_groups = ["${local.int_lb_security_groups}"]
  internal        = "true"

  cross_zone_load_balancing   = "true"
  idle_timeout                = "${local.backend_timeout}"
  connection_draining         = "${local.connection_draining}"
  connection_draining_timeout = "${local.connection_draining_timeout}"
  bucket                      = "${local.access_logs_bucket}"
  bucket_prefix               = "${local.common_name}-elb"
  interval                    = 60
  listener                    = ["${local.listener}"]
  health_check                = ["${local.health_check}"]

  tags = "${local.tags}"
}



###############################################
# Create INTERNAL route53 entry for spg lb
###############################################

resource "aws_route53_record" "dns_int_entry" {
  zone_id = "${local.public_zone_id}"
  name    = "${local.application_endpoint}-${local.app_submodule}-int.${local.external_domain}"
  type    = "A"

  alias {
    name                   = "${module.create_app_elb.environment_elb_dns_name}"
    zone_id                = "${module.create_app_elb.environment_elb_zone_id}"
    evaluate_target_health = false
  }
}


