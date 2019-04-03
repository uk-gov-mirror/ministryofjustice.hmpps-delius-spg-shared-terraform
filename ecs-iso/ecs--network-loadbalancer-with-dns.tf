
############################################
# CREATE INTERNAL LB FOR spg
############################################
module "create_app_nlb_ext" {
  //  source              = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//loadbalancer//alb//create_lb"
  source                    = "../modules/loadbalancer/nlb/create_nlb"

  az_lb_eip_allocation_ids  = "${local.az_lb_eip_allocation_ids}"
  internal                  = false
  lb_name                   = "${local.common_name}"
  public_subnet_ids         = "${local.public_subnet_ids}"
  s3_bucket_name            = "${local.access_logs_bucket}"
  tags                      = "${local.tags}"
}



###############################################
# Create INTERNAL route53 entry for spg lb
###############################################

resource "aws_route53_record" "dns_ext_entry" {
  zone_id = "${local.public_zone_id}"
  name    = "${local.application_endpoint}-ext"
  type    = "A"

  alias {
    name                   = "${module.create_app_nlb_ext.lb_dns_name}"
    zone_id                = "${module.create_app_nlb_ext.lb_zone_id}"
    evaluate_target_health = false
  }
}




###################################################################

