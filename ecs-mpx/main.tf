terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = ">= 2.1.0"
  #2.1.0 needed for ecs elb graceperiod, is set in the local elb module
  #version = "~> 1.16"
}

####################################################
# DATA SOURCE MODULES FROM OTHER TERRAFORM BACKENDS
####################################################
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
### Getting ACM Cert
#-------------------------------------------------------------
data "aws_acm_certificate" "cert" {
  domain      = "*.${data.terraform_remote_state.common.external_domain}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
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

#-------------------------------------------------------------
### Getting the security groups details
#-------------------------------------------------------------
data "terraform_remote_state" "security-groups" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "spg/security-groups/terraform.tfstate"
    region = "${var.region}"
  }
}

#-------------------------------------------------------------
### Getting the s3bucket
#-------------------------------------------------------------
data "terraform_remote_state" "s3buckets" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "spg/s3buckets/terraform.tfstate"
    region = "${var.region}"
  }
}

#-------------------------------------------------------------
### Getting the ecr
#-------------------------------------------------------------
data "terraform_remote_state" "ecr" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "spg/ecr/terraform.tfstate"
    region = "${var.region}"
  }
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

####################################################
# Locals
####################################################

locals {
  ami_id                         = "${data.aws_ami.amazon_ami.id}"
  account_id                     = "${data.terraform_remote_state.common.common_account_id}"
  vpc_id                         = "${data.terraform_remote_state.common.vpc_id}"
  cidr_block                     = "${data.terraform_remote_state.common.vpc_cidr_block}"
  internal_domain                = "${data.terraform_remote_state.common.internal_domain}"
  private_zone_id                = "${data.terraform_remote_state.common.private_zone_id}"
  external_domain                = "${data.terraform_remote_state.common.external_domain}"
  public_zone_id                 = "${data.terraform_remote_state.common.public_zone_id}"
  environment_identifier         = "${data.terraform_remote_state.common.environment_identifier}"
  short_environment_name         = "${data.terraform_remote_state.common.short_environment_name}"
  region                         = "${var.region}"
  spg_app_name                   = "${data.terraform_remote_state.common.spg_app_name}"
  app_submodule                  = "mpx"
  private_subnet_map             = "${data.terraform_remote_state.common.private_subnet_map}"
  ext_lb_security_groups         = ["${data.terraform_remote_state.security-groups.security_groups_sg_external_lb_id}"]
  int_lb_security_groups         = ["${data.terraform_remote_state.security-groups.security_groups_sg_internal_lb_id}"]
  access_logs_bucket             = "${data.terraform_remote_state.common.common_s3_lb_logs_bucket}"
  ssh_deployer_key               = "${data.terraform_remote_state.common.common_ssh_deployer_key}"
  monitoring_server_internal_url = "tmpdoesnotexist"                                                                    # "${data.terraform_remote_state.common.monitoring_server_internal_url}"
  app_hostnames                  = "${data.terraform_remote_state.common.app_hostnames}"
  certificate_arn                = ["${data.aws_acm_certificate.cert.arn}"]
  image_url                      = "${data.terraform_remote_state.ecr.ecr_repository_url}"
  image_version                  = "latest"
  public_subnet_ids              = ["${data.terraform_remote_state.common.public_subnet_ids}"]
  private_subnet_ids             = ["${data.terraform_remote_state.common.private_subnet_ids}"]
  public_cidr_block              = ["${data.terraform_remote_state.common.db_cidr_block}"]
  config-bucket                  = "${data.terraform_remote_state.common.common_s3-config-bucket}"
  ecs_service_role               = "${data.terraform_remote_state.iam.iam_role_ext_ecs_role_arn}"
  service_desired_count          = "1"
  cloudwatch_log_retention       = "${var.cloudwatch_log_retention}"
  s3_bucket_config               = "${var.s3_bucket_config}"
  spg_build_inv_dir              = "${var.spg_build_inv_dir}"
  instance_profile               = "${data.terraform_remote_state.iam.iam_policy_ext_app_instance_profile_name}"
  sg_map_ids                     = "${data.terraform_remote_state.common.sg_map_ids}"
  instance_security_groups = [
    "${data.terraform_remote_state.security-groups.security_groups_sg_external_instance_id}",
    "${data.terraform_remote_state.common.sg_map_ids.bastion_in_sg_id  }",
    "${data.terraform_remote_state.common.common_sg_outbound_id}",
//    "${data.terraform_remote_state.security-groups.sg_spg_api_in_id}",
    "${local.sg_map_ids["internal_inst_sg_id"]}"
  ]

  # "${data.terraform_remote_state.common.monitoring_server_client_sg_id}",



  listener = [
    {
      instance_port     = "61616"
      instance_protocol = "TCP"
      lb_port           = "61616"
      lb_protocol       = "TCP"
    },
    {
      instance_port     = "8181"
      instance_protocol = "HTTP"
      lb_port           = "8181"
      lb_protocol       = "HTTP"
    },
    {
      instance_port     = "8989"
      instance_protocol = "HTTP"
      lb_port           = "8989"
      lb_protocol       = "HTTP"
    },

    {
      instance_port     = "9001"
      instance_protocol = "TCP"
      lb_port           = "9001"
      lb_protocol       = "TCP"
    },

  ]

  health_check = [
    {
      target              = "HTTP:8181/cxf/"
      interval            = 60
      healthy_threshold   = 2
      #set to 10 to allow spg 10 mins to spin up
      unhealthy_threshold = 10
      timeout             = 5
    },
  ]


}

####################################################
# Application Specific
####################################################
module "ecs-mpx" {
  source                         = "../modules/ecs-elb"
  app_name                       = "${local.spg_app_name}"
  app_submodule                  = "${local.app_submodule}"
  certificate_arn                = ["${local.certificate_arn}"]
  image_url                      = "${local.image_url}"
  image_version                  = "${local.image_version}"
  short_environment_name         = "${local.short_environment_name}"
  environment_identifier         = "${local.environment_identifier}"
  public_subnet_ids              = ["${local.public_subnet_ids}"]
  private_subnet_ids             = ["${local.private_subnet_ids}"]
  tags                           = "${var.tags}"
  instance_security_groups       = ["${local.instance_security_groups}"]
  ext_lb_security_groups         = ["${local.ext_lb_security_groups}"]
  int_lb_security_groups         = ["${local.int_lb_security_groups}"]
  vpc_id                         = "${local.vpc_id}"
  config_bucket                  = "${local.config-bucket}"
  access_logs_bucket             = "${local.access_logs_bucket}"
  public_zone_id                 = "${local.public_zone_id}"
  external_domain                = "${local.external_domain}"
  internal_domain                = "${local.internal_domain}"
  alb_backend_port               = "9001"
  alb_http_port                  = "80"
  alb_https_port                 = "443"
  deregistration_delay           = "90"
  backend_app_port               = "8181"
  backend_app_protocol           = "HTTP"
  backend_app_template_file      = "template.json"
  backend_check_app_path         = "/cxf/"
  backend_check_interval         = "120"
  backend_ecs_cpu_units          = "256"
  backend_ecs_desired_count      = "1"
  backend_ecs_memory             = "2048"
  backend_healthy_threshold      = "2"
  backend_maxConnections         = "500"
  backend_maxConnectionsPerRoute = "200"
  backend_return_code            = "200,302"
  backend_timeout                = "60"
  backend_timeoutInSeconds       = "60"
  backend_timeoutRetries         = "10"
  backend_unhealthy_threshold    = "10"
  target_type                    = "instance"
  cloudwatch_log_retention       = "${local.cloudwatch_log_retention}"
  keys_dir                       = "/opt/spg"
  kibana_host                    = "${local.monitoring_server_internal_url}"
  app_hostnames                  = "${local.app_hostnames}"
  region                         = "${local.region}"
  ecs_service_role               = "${local.ecs_service_role}"
  service_desired_count          = "${local.service_desired_count}"
  user_data                      = "../user_data/spg_user_data.sh"
  volume_size                    = "50"
  ebs_device_name                = "/dev/xvdb"
  ebs_volume_type                = "standard"
  ebs_volume_size                = "50"
  ebs_encrypted                  = "true"
  instance_type                  = "t2.medium"
  asg_desired                    = "2"
  asg_max                        = "3"
  asg_min                        = "2"
  associate_public_ip_address    = true
  ami_id                         = "${local.ami_id}"
  instance_profile               = "${local.instance_profile}"
  ssh_deployer_key               = "${local.ssh_deployer_key}"
  s3_bucket_config = "${var.s3_bucket_config}"
  spg_build_inv_dir = "${var.spg_build_inv_dir}"
  health_check = "${local.health_check}"
  listener = "${local.listener}"
}

