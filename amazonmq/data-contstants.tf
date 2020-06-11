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
  filter {
    name   = "description"
    values = ["amzn2-ami-ecs-hvm-2.0.20200603-x86_64-ebs"]
  }

  owners = ["591542846629"] # AWS
}


