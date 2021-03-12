module "spg-infrastructure-approve-pipeline" {
  source            = "git::https://github.com/ministryofjustice/hmpps-delius-spg-codepipeline.git//terraform/ci-components/codepipeline?ref=feature/ALS-2862-codepipeline-plan-apply"
  approval_required = true
  artefacts_bucket  = local.artefacts_bucket
  pipeline_name     = "spgw-test-approve-pipeline"
  iam_role_arn      = local.iam_role_arn
  log_group         = local.log_group_name
  tags              = local.tags
  cache_bucket      = local.cache_bucket
  codebuild_name    = local.legacy_infrastructure_approve_pipeline_name
  github_repositories = {
    SourceArtifact = ["hmpps-delius-spg-shared-terraform", var.branch_name]
  }
  stages = [
    {
      name = "Build"
      actions = [
        {
          action_name      = "CRC"
          codebuild_name   = local.stack_builder_name_plan
          input_artifacts  = "SourceArtifact"
          output_artifacts = "BuildCrcArtifact"
          namespace        = "BuildCrcVariables"
          action_env = jsonencode(
            [
              {
                "name" : "sub_project",
                "value" : var.sub_project_crc,
                "type" : "PLAINTEXT"
              },
              {
                "name" : "environment_name",
                "value" : var.environment_name,
                "type" : "PLAINTEXT"
              },
              {
                "name" : "image_version",
                "value" : var.image_version,
                "type" : "PLAINTEXT"
              }
            ]
          )
        },
        {
          action_name     = "CRC Approval"
          action_category = "Approval"
          provider = "Manual"
        },
        {
          action_name      = "CRC"
          codebuild_name   = local.stack_builder_name_apply
          input_artifacts  = "SourceArtifact"
          output_artifacts = "BuildCrcArtifact"
          namespace        = "BuildCrcVariables"
          action_env = jsonencode(
          [
            {
              "name" : "sub_project",
              "value" : var.sub_project_crc,
              "type" : "PLAINTEXT"
            },
            {
              "name" : "environment_name",
              "value" : var.environment_name,
              "type" : "PLAINTEXT"
            },
            {
              "name" : "image_version",
              "value" : var.image_version,
              "type" : "PLAINTEXT"
            }
          ]
          )
        },
        {
          action_name      = "MPX"
          codebuild_name   = local.stack_builder_name
          input_artifacts  = "SourceArtifact"
          output_artifacts = "BuildMpxArtifact"
          namespace        = "BuildMpxVariables"
          action_env = jsonencode(
            [
              {
                "name" : "sub_project",
                "value" : var.sub_project_mpx,
                "type" : "PLAINTEXT"
              },
              {
                "name" : "environment_name",
                "value" : var.environment_name,
                "type" : "PLAINTEXT"
              },
              {
                "name" : "image_version",
                "value" : var.image_version,
                "type" : "PLAINTEXT"
              }
            ]
          )
        },
        {
          action_name      = "ISO"
          codebuild_name   = local.stack_builder_name
          input_artifacts  = "SourceArtifact"
          output_artifacts = "BuildIsoArtifact"
          namespace        = "BuildIsoVariables"
          action_env = jsonencode(
            [
              {
                "name" : "sub_project",
                "value" : var.sub_project_iso,
                "type" : "PLAINTEXT"
              },
              {
                "name" : "environment_name",
                "value" : var.environment_name,
                "type" : "PLAINTEXT"
              },
              {
                "name" : "image_version",
                "value" : var.image_version,
                "type" : "PLAINTEXT"
              }
            ]
          )
        }
      ]
    },
  ]
}