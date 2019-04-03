
# #-------------------------------------------
# ### S3 bucket for config
# #--------------------------------------------
module "s3config_bucket" {
  source         = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//s3bucket//s3bucket_without_policy"
  s3_bucket_name = "${local.full_common_name}"
  tags           = "${local.tags}"
}



//data "template_file" "s3conf_logs_policy" {
//  template = "${file("${local.s3_lb_policy_file}")}"
//
//  vars {
//    s3_bucket_name   = "${module.s3_lb_logs_bucket.s3_bucket_name}"
//    s3_bucket_prefix = "${var.short_environment_name}-*"
//    aws_account_id   = "${data.aws_caller_identity.current.account_id}"
//    lb_account_id    = "${var.lb_account_id}"
//  }
//}
//
//module "s3alb_logs_policy" {
//  source       = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//s3bucket//s3bucket_policy"
//  s3_bucket_id = "${module.s3_lb_logs_bucket.s3_bucket_name}"
//  policyfile   = "${data.template_file.s3alb_logs_policy.rendered}"
//}



# #-------------------------------------------
# ### S3 bucket for logs
# #--------------------------------------------
module "s3_lb_logs_bucket" {
  source         = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//s3bucket//s3bucket_without_policy"
  s3_bucket_name = "${local.full_common_name}-lb-logs"
  tags           = "${local.tags}"
}

#-------------------------------------------
### Attaching S3 bucket policy to ALB logs bucket
#--------------------------------------------

data "template_file" "s3alb_logs_policy" {
  template = "${file("${local.s3_lb_policy_file}")}"

  vars {
    s3_bucket_name   = "${module.s3_lb_logs_bucket.s3_bucket_name}"
    s3_bucket_prefix = "${var.short_environment_name}-*"
    aws_account_id   = "${data.aws_caller_identity.current.account_id}"
    lb_account_id    = "${var.lb_account_id}"
  }
}

module "s3alb_logs_policy" {
  source       = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//s3bucket//s3bucket_policy"
  s3_bucket_id = "${module.s3_lb_logs_bucket.s3_bucket_name}"
  policyfile   = "${data.template_file.s3alb_logs_policy.rendered}"
}
