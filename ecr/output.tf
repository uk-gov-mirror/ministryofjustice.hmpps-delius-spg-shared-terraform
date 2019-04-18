####################################################
# ECR - Application specific
####################################################

output "ecr_repository_url" {
  value = "${module.ecr.repo_repository_url}"
}

output "ecr_repository_arn" {
  value = "${module.ecr.repo_repository_arn}"
}

output "ecr_repository_name" {
  value = "${module.ecr.repo_repository_name}"
}

