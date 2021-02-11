resource "aws_ssm_parameter" "pipeline_name" {
  name      = "/codepipeline/spg/pipeline_name"
  type      = "String"
  value     = var.pipeline_name
  overwrite = true
}