# Load in VPC state data for subnet placement
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "common" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "spg/common/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "engineering_nat" {
  backend = "s3"

  config = {
    bucket   = var.eng_remote_state_bucket_name
    key      = "natgateway/terraform.tfstate"
    region   = var.region
    role_arn = var.eng_role_arn
  }
}

# Load in VPC security groups to reference bastion ssh inbound group for ecs hosts
data "terraform_remote_state" "vpc_security_groups" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "security-groups/terraform.tfstate"
    region = var.region
  }
}

# Get current context for things like account id
data "aws_caller_identity" "current" {
}

data "template_file" "elk-audit_accesspolicy_template" {
  template = file(
    "${path.module}/templates/es_access_open_filebeat_policy.tpl",
  )

  vars = {
    region      = var.region
    account_id  = data.aws_caller_identity.current.account_id
    domain      = var.elk-audit_conf["es_domain"]
    kibana_role = aws_iam_role.elk-audit_kibana_role.arn
  }
}

data "template_file" "cwlogs_accesspolicy_template" {
  template = file("${path.module}/templates/cwlogs_access_policy.tpl")

  vars = {}
}

data "template_file" "elk-audit_kibana_assume_policy_template" {
  template = file(
    "${path.module}/templates/iam/elk-audit_kibana_assume_policy.tpl",
  )

  vars = {}
}

