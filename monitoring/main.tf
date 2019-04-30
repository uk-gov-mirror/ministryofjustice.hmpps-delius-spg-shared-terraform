terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
  required_version = "~> 0.11"
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 1.16"
}

# Shared data and constants

locals {
//  db_name           = "${var.project_name}${var.environment_type}"
//  environment_name  = "${var.project_name}-${var.environment_type}"
  tags              = "${merge(var.tags, map("Build", "${var.build_tag}"))}"

  short_environment_name = "${data.terraform_remote_state.common.short_environment_name}"
  app_hostnames          = "${data.terraform_remote_state.common.app_hostnames}"
  project_name_abbreviated = "${data.terraform_remote_state.common.project_name_abbreviated}"
  spg_app_name = "${data.terraform_remote_state.common.spg_app_name}"




  //  db_cpu_alarm      = "80"
//  db_storage_alarm  = "${var.db_storage * 0.2}"
//  db_memory_alarm   = "${var.db_memory * 0.1}"
//  redis_cpu_alarm   = "90"
//  redis_swap_alarm  = "50000000"
}
