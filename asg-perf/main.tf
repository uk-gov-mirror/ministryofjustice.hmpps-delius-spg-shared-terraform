terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = ">= 2.1.0"
}

#-------------------------------------------------------------
### Getting the current vpc
#-------------------------------------------------------------
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "vpc/terraform.tfstate"
    region = "${var.region}"
  }
}

#-------------------------------------------------------------
### Getting the shared vpc security groups
#-------------------------------------------------------------
data "terraform_remote_state" "vpc_security_groups" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "security-groups/terraform.tfstate"
    region = "${var.region}"
  }
}

#-------------------------------------------------------------
### Getting the common details
#-------------------------------------------------------------
data "terraform_remote_state" "common" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "spg/common/terraform.tfstate"
    region = "${var.region}"
  }
}

#-------------------------------------------------------------
### Getting the IAM details
#-------------------------------------------------------------
data "terraform_remote_state" "iam" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "spg/iam/terraform.tfstate"
    region = "${var.region}"
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user_data/setup.sh")}"
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

locals {
  app_name                 = "spg-perf"
  hmpps_asset_name_prefix  = "${data.terraform_remote_state.common.hmpps_asset_name_prefix}"
  app_hostnames            = "${data.terraform_remote_state.common.app_hostnames}"
  app_submodule            = "spg-perf-test"
  common_name              = "${local.hmpps_asset_name_prefix}-${local.app_hostnames["external"]}-${local.app_submodule}"

  asg_desired             = "0"
  asg_max                 = "1"
  asg_min                 = "0"
}