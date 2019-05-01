terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 1.16"
}

####################################################
# Locals
####################################################

locals {
  region                 = "${var.region}"
  spg_app_name           = "${data.terraform_remote_state.common.spg_app_name}"
  environment_identifier = "${data.terraform_remote_state.common.environment_identifier}"
  eng_root_arn           = "${data.terraform_remote_state.common.eng_root_arn}"
  ecr_policy             = "../policies/ecr_policy.json"
  role_arns               = ["${data.terraform_remote_state.iam.iam_policy_int_app_role_arn}",
                             "${data.terraform_remote_state.iam.iam_policy_ext_app_role_arn}"]

  common_name  = "${local.environment_identifier}-${local.spg_app_name}"

}



############################################
# CREATE ECR FOR APPS
############################################
data "template_file" "ecr_policy" {
  template = "${file("${local.ecr_policy}")}"

  vars {
    role_arn     = "${jsonencode(local.role_arns)}"
//    eng_root_arn = "${local.eng_root_arn}"
  }
}




module "ecr" {
  source   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//ecr"
  app_name = "${local.common_name}"
  policy   = "${data.template_file.ecr_policy.rendered}"
}
