locals {
  prefix = "spgw"

  legacy_infrastructure_develop_pipeline_name     = "delius-${local.prefix}-legacy-spg-infrastructure"
  legacy_infrastructure_develop_pipeline_name_dev = "${local.legacy_infrastructure_develop_pipeline_name}-develop"
  legacy_infrastructure_release_pipeline_name_rel = "${local.legacy_infrastructure_develop_pipeline_name}-release-${var.pipeline_name}"
  legacy_infrastructure_approve_pipeline_name_app = "${local.legacy_infrastructure_develop_pipeline_name}-approve-${var.pipeline_name}"

  iam_role_arn     = data.terraform_remote_state.common.outputs.codebuild_info["iam_role_arn"]
  cache_bucket     = data.terraform_remote_state.common.outputs.codebuild_info["build_cache_bucket"]
  log_group_name   = data.terraform_remote_state.common.outputs.codebuild_info["log_group"]
  artefacts_bucket = data.terraform_remote_state.common.outputs.codebuild_info["artefacts_bucket"]
  tags             = data.terraform_remote_state.common.outputs.tags

  stack_builder_name       = data.terraform_remote_state.spg-codebuild.outputs.spg_stack_builder_name
  stack_builder_name_plan  = data.terraform_remote_state.spg-codebuild.outputs.spg_stack_builder_name
  stack_builder_name_apply = data.terraform_remote_state.spg-codebuild.outputs.spg_stack_builder_name
}