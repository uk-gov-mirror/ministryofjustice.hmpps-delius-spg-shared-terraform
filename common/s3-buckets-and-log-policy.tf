# #-------------------------------------------
# ### S3 bucket for backups
# #--------------------------------------------
module "s3_backups_bucket" {
  source         = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules/s3bucket/s3bucket_without_policy?ref=terraform-0.12"
  s3_bucket_name = "${local.full_common_name}-backups"
  tags           = local.tags
}

# #-------------------------------------------
# ### S3 bucket for logs
# #--------------------------------------------
module "s3_lb_logs_bucket" {
  source         = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules/s3bucket/s3bucket_without_policy?ref=terraform-0.12"
  s3_bucket_name = "${local.full_common_name}-lb-logs"
  tags           = local.tags
}

#-------------------------------------------
### Attaching S3 bucket policy to ALB logs bucket
#--------------------------------------------

data "template_file" "s3alb_logs_policy" {
  template = file(local.s3_lb_policy_file)

  vars = {
    s3_bucket_name   = module.s3_lb_logs_bucket.s3_bucket_name
    s3_bucket_prefix = "${local.hmpps_asset_name_prefix}-*"
    aws_account_id   = data.aws_caller_identity.current.account_id
    lb_account_id    = local.lb_account_id
  }
}

module "s3alb_logs_policy" {
  source       = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules/s3bucket/s3bucket_policy?ref=terraform-0.12"
  s3_bucket_id = module.s3_lb_logs_bucket.s3_bucket_name
  policyfile   = data.template_file.s3alb_logs_policy.rendered
}

