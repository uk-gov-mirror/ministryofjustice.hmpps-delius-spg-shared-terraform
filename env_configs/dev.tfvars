# This is used for ALB logs to S3 bucket.
# This is fixed for each region. if region changes, this changes
lb_account_id = "652711504416"

# VPC variables
cloudwatch_log_retention = 14

# ROUTE53 ZONE probation.hmpps.dsd.io
route53_hosted_zone_id = "Z3VDCLGXC4HLOW"

# ENVIRONMENT REMOTE STATES
eng-remote_state_bucket_name = "tf-eu-west-2-hmpps-eng-dev-remote-state"

# ENVIRONMENT ROLE ARNS
eng_role_arn = "arn:aws:iam::895523100917:role/terraform"
