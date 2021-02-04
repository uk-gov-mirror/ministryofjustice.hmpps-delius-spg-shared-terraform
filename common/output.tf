####################################################
# Common
####################################################
output "region" {
  value = data.aws_region.current.name
}

output "common_account_id" {
  value = data.aws_caller_identity.current.account_id
}

# S3 Buckets
output "common_s3_backups_bucket" {
  value = module.s3_backups_bucket.s3_bucket_name
}

output "common_s3_lb_logs_bucket" {
  value = module.s3_lb_logs_bucket.s3_bucket_name
}

# SSH KEY
output "common_ssh_deployer_key" {
  value = local.ssh_deployer_key
}

# ENVIRONMENTS SETTINGS

# LOCAL OUTPUTS
output "vpc_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
}

output "vpc_cidr_block" {
  value = data.terraform_remote_state.vpc.outputs.vpc_cidr_block
}

output "internal_domain" {
  value = data.terraform_remote_state.vpc.outputs.private_zone_name
}

output "private_zone_id" {
  value = data.terraform_remote_state.vpc.outputs.private_zone_id
}

output "external_domain" {
  value = data.terraform_remote_state.vpc.outputs.public_zone_name
}

output "public_zone_id" {
  value = data.terraform_remote_state.vpc.outputs.public_zone_id
}

output "strategic_external_domain" {
  value = "${var.public_dns_child_zone}.${var.public_dns_parent_zone}"
}

output "strategic_public_zone_id" {
  value = var.route53_strategic_hosted_zone_id
}

output "common_name" {
  value = local.common_name
}

output "lb_account_id" {
  value = local.lb_account_id
}

output "role_arn" {
  value = local.role_arn
}

output "spg_app_name" {
  value = local.spg_app_name
}

output "environment_identifier" {
  value = local.environment_identifier
}

output "short_environment_name" {
  value = local.short_environment_name
}

output "project_name_abbreviated" {
  value = local.project_name_abbreviated
}

output "hmpps_asset_name_prefix" {
  value = local.hmpps_asset_name_prefix
}

output "remote_state_bucket_name" {
  value = local.remote_state_bucket_name
}

output "s3_lb_policy_file" {
  value = "policies/s3_alb_policy.json"
}

output "common_engineering_certificates_s3_bucket" {
  value = data.terraform_remote_state.eng_remote_certificates_s3bucket.outputs.s3bucket_private
}

/*
output "monitoring_server_external_url" {
  value = "${data.terraform_remote_state.monitor.monitoring_server_external_url}"
}

output "monitoring_server_internal_url" {
  value = "${data.terraform_remote_state.monitor.monitoring_server_internal_url}"
}

output "monitoring_server_client_sg_id" {
  value = "${data.terraform_remote_state.monitor.monitoring_server_client_sg_id}"
}
*/

output "private_subnet_map" {
  value = {
    az1 = data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az1
    az2 = data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az2
    az3 = data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az3
  }
}

output "public_cidr_block" {
  value = [
    data.terraform_remote_state.vpc.outputs.vpc_public-subnet-az1-cidr_block,
    data.terraform_remote_state.vpc.outputs.vpc_public-subnet-az2-cidr_block,
    data.terraform_remote_state.vpc.outputs.vpc_public-subnet-az3-cidr_block,
  ]
}

output "private_cidr_block" {
  value = [
    data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az1-cidr_block,
    data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az2-cidr_block,
    data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az3-cidr_block,
  ]
}

output "public_subnet_ids" {
  value = [
    data.terraform_remote_state.vpc.outputs.vpc_public-subnet-az1,
    data.terraform_remote_state.vpc.outputs.vpc_public-subnet-az2,
    data.terraform_remote_state.vpc.outputs.vpc_public-subnet-az3,
  ]
}

output "private_subnet_ids" {
  value = [
    data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az1,
    data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az2,
    data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az3,
  ]
}

//# Security groups
//output "sg_map_ids" {
//  value = "${local.sg_map_ids}"
//}

# spg hosts
output "app_hostnames" {
  value = local.app_hostnames
}

