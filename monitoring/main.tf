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
  tags              = "${merge(var.tags, map("Build", "${var.build_tag}"))}"
  short_environment_name = "${data.terraform_remote_state.common.short_environment_name}"
  app_hostnames          = "${data.terraform_remote_state.common.app_hostnames}"
  project_name_abbreviated = "${data.terraform_remote_state.common.project_name_abbreviated}"
  spg_app_name = "${data.terraform_remote_state.common.spg_app_name}"

}
