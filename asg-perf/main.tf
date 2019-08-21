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
  most_recent = true

  filter {
    name   = "description"
    values = ["Amazon Linux AMI *"]
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

locals {
  app_name                 = "spg-perf"
  hmpps_asset_name_prefix  = "${data.terraform_remote_state.common.hmpps_asset_name_prefix}"
  app_hostnames            = "${data.terraform_remote_state.common.app_hostnames}"
  app_submodule            = "spg-perf-test"
  common_name              = "${local.hmpps_asset_name_prefix}-${local.app_hostnames["external"]}-${local.app_submodule}"
  sg_map_ids               = "${data.terraform_remote_state.common.sg_map_ids}"
  instance_security_groups = [
    "${local.sg_map_ids["external_inst_sg_id"]}",
    "${local.sg_map_ids["internal_inst_sg_id"]}",
    "${local.sg_map_ids["bastion_in_sg_id"]}",
    "${local.sg_map_ids["outbound_sg_id"]}",
    "${aws_security_group.spg_perf.id}",
  ]

  #                                  "${data.terraform_remote_state.vpc_security_groups.sg_ssh_bastion_in_id}",

  asg_desired             = "1"
  asg_max                 = "1"
  asg_min                 = "1"
}