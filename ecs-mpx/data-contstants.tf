#-------------------------------------------------------------
### Getting ACM Cert
#-------------------------------------------------------------
data "aws_acm_certificate" "cert" {
  domain      = "*.${data.terraform_remote_state.common.external_domain}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

#-------------------------------------------------------------
### Getting the latest amazon ami
#-------------------------------------------------------------
data "aws_ami" "amazon_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*amzn2-ami-ecs-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["591542846629"] # AWS
}


# Template files for ECS secrets task role and execution role definitions
data "template_file" "ecs_tasks_assumerole_template" {
  template = "${file("${path.module}/templates/iam/iam_exec_policy.tpl")}"
  vars = {
    region           = "${var.region}"
    aws_account_id   = "${data.aws_caller_identity.current.account_id}"
    project_name     = "${var.project_name}"
    environment_type = "${var.environment_type}"
  }
}

# Template files for ECS secrets task role and execution role definitions
data "template_file" "ecstasks_assumerole_template" {
  template = "${file("${path.module}/templates/iam/ecstasks_assumerole_policy.tpl")}"
  vars     = {}
}

data "aws_caller_identity" "current" {}
