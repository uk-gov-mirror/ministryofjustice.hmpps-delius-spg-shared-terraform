module "spg-infrastructure-release-pipeline" {
  source            = "git::https://github.com/ministryofjustice/hmpps-delius-spg-codepipeline.git//terraform/ci-components/codepipeline?ref=main"
  approval_required = false
  artefacts_bucket  = local.artefacts_bucket
  pipeline_name     = local.legacy_infrastructure_release_pipeline_name
  iam_role_arn      = local.iam_role_arn
  log_group         = local.log_group_name
  tags              = local.tags
  cache_bucket      = local.cache_bucket
  codebuild_name    = local.legacy_infrastructure_release_pipeline_name
  github_repositories = {
    SourceArtifact = ["hmpps-delius-spg-shared-terraform", var.branch_name]
  }
  stages = [
    {
      name = "Build"
      actions = [
        {
          action_name      = "CRC"
          codebuild_name   = local.stack_builder_name
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
              }
            ]
          )
        }
      ]
    },
    {
      name = "Build-Terraform-ELK-Service"
      actions = [
        {
          action_name      = "Elk-Service"
          codebuild_name   = local.stack_builder_name
          input_artifacts  = "SourceArtifact"
          output_artifacts = "BuildElkServiceArtifacts"
          namespace        = "BuildElkServiceVariable"
          action_env = jsonencode(
            [
              {
                "name" : "sub_project",
                "value" : var.sub_project_elk_service,
                "type" : "PLAINTEXT"
              },
              {
                "name" : "environment_name",
                "value" : var.environment_name,
                "type" : "PLAINTEXT"
              }
            ]
          )
        }
      ]
    },
    {
      name = "Build-Terraform-ELK-Domains"
      actions = [
        {
          action_name      = "Elk-Domains"
          codebuild_name   = local.stack_builder_name
          input_artifacts  = "SourceArtifact"
          output_artifacts = "BuildElkDomainsArtifacts"
          namespace        = "BuildElkDomainsVariable"
          action_env = jsonencode(
            [
              {
                "name" : "sub_project",
                "value" : var.sub_project_elk_domains,
                "type" : "PLAINTEXT"
              },
              {
                "name" : "environment_name",
                "value" : var.environment_name,
                "type" : "PLAINTEXT"
              }
            ]
          )
        }
      ]
    },
    {
      name = "Build-Terraform-IAM"
      actions = [
        {
          action_name      = "IAM"
          codebuild_name   = local.stack_builder_name
          input_artifacts  = "SourceArtifact"
          output_artifacts = "BuildIamArtifacts"
          namespace        = "BuildIamVariable"
          action_env = jsonencode(
            [
              {
                "name" : "sub_project",
                "value" : var.sub_project_iam,
                "type" : "PLAINTEXT"
              },
              {
                "name" : "environment_name",
                "value" : var.environment_name,
                "type" : "PLAINTEXT"
              }
            ]
          )
        },
        {
          action_name      = "Iam-Spg-App-Policies"
          codebuild_name   = local.stack_builder_name
          input_artifacts  = "SourceArtifact"
          output_artifacts = "BuildIamAppPoliciesArtifacts"
          namespace        = "BuildIamAppPoliciesVariable"
          action_env = jsonencode(
            [
              {
                "name" : "sub_project",
                "value" : var.sub_project_iam_spg_app_policies,
                "type" : "PLAINTEXT"
              },
              {
                "name" : "environment_name",
                "value" : var.environment_name,
                "type" : "PLAINTEXT"
              }
            ]
          )
        },
        {
          action_name      = "Kms-Certificates-Spg"
          codebuild_name   = local.stack_builder_name
          input_artifacts  = "SourceArtifact"
          output_artifacts = "BuildKmsCertificatesArtifacts"
          namespace        = "BuildKmsCertificatesVariable"
          action_env = jsonencode(
            [
              {
                "name" : "sub_project",
                "value" : var.sub_project_kms_certificates_spg,
                "type" : "PLAINTEXT"
              },
              {
                "name" : "environment_name",
                "value" : var.environment_name,
                "type" : "PLAINTEXT"
              }
            ]
          )
        },
        {
          action_name      = "Security-Groups-And-Rules"
          codebuild_name   = local.stack_builder_name
          input_artifacts  = "SourceArtifact"
          output_artifacts = "BuildSecurityGroupsArtifacts"
          namespace        = "BuildSecurityGroupsVariable"
          action_env = jsonencode(
            [
              {
                "name" : "sub_project",
                "value" : var.sub_project_security_groups_and_rules,
                "type" : "PLAINTEXT"
              },
              {
                "name" : "environment_name",
                "value" : var.environment_name,
                "type" : "PLAINTEXT"
              }
            ]
          )
        },
      ]
    },
    {
      name = "Build-Terrafom-Misc"
      actions = [
        {
          action_name      = "Amazonmq"
          codebuild_name   = local.stack_builder_name
          input_artifacts  = "SourceArtifact"
          output_artifacts = "BuildAmazonMqArtifacts"
          namespace        = "BuildAmazonMqVariable"
          action_env = jsonencode(
            [
              {
                "name" : "sub_project",
                "value" : var.sub_project_amazonmq,
                "type" : "PLAINTEXT"
              },
              {
                "name" : "environment_name",
                "value" : var.environment_name,
                "type" : "PLAINTEXT"
              }
            ]
          )
        },
        {
          action_name      = "Common"
          codebuild_name   = local.stack_builder_name
          input_artifacts  = "SourceArtifact"
          output_artifacts = "BuildCommonArtifacts"
          namespace        = "BuildCommonVariable"
          action_env = jsonencode(
            [
              {
                "name" : "sub_project",
                "value" : var.sub_project_common,
                "type" : "PLAINTEXT"
              },
              {
                "name" : "environment_name",
                "value" : var.environment_name,
                "type" : "PLAINTEXT"
              }
            ]
          )
        },
        {
          action_name      = "Dynamodb-Sequence-Generator"
          codebuild_name   = local.stack_builder_name
          input_artifacts  = "SourceArtifact"
          output_artifacts = "BuildDynamoDbArtifacts"
          namespace        = "BuildDynamoDbVariable"
          action_env = jsonencode(
            [
              {
                "name" : "sub_project",
                "value" : var.sub_project_dynamodb_sequence_generator,
                "type" : "PLAINTEXT"
              },
              {
                "name" : "environment_name",
                "value" : var.environment_name,
                "type" : "PLAINTEXT"
              }
            ]
          )
        },
        {
          action_name      = "Psn-Proxy-Route-53"
          codebuild_name   = local.stack_builder_name
          input_artifacts  = "SourceArtifact"
          output_artifacts = "BuildRoute53Artifacts"
          namespace        = "BuildRoute53Variable"
          action_env = jsonencode(
            [
              {
                "name" : "sub_project",
                "value" : var.sub_project_psn_proxy_route_53,
                "type" : "PLAINTEXT"
              },
              {
                "name" : "environment_name",
                "value" : var.environment_name,
                "type" : "PLAINTEXT"
              }
            ]
          )
        }
      ]
    },
    {
      name = "Build-Terrafom-Monitoring"
      actions = [
        {
          action_name      = "Monitoring"
          codebuild_name   = local.stack_builder_name
          input_artifacts  = "SourceArtifact"
          output_artifacts = "BuildMonitoringArtifacts"
          namespace        = "BuildMonitoringVariable"
          action_env = jsonencode(
            [
              {
                "name" : "sub_project",
                "value" : var.sub_project_monitoring,
                "type" : "PLAINTEXT"
              },
              {
                "name" : "environment_name",
                "value" : var.environment_name,
                "type" : "PLAINTEXT"
              }
            ]
          )
        }
      ]
    }
  ]
}