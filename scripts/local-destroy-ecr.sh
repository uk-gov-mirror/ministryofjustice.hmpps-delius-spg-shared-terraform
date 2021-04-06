#!/bin/sh
set -e

## Assume eng role
export AWS_PROFILE=hmpps-engineering-admin
aws sts get-caller-identity

aws ecr delete-repository --region eu-west-2 --repository-name hmpps/spg --force
aws ecr delete-repository --region eu-west-2 --repository-name hmpps/spg-extended-wiremock --force
aws ecr delete-repository --region eu-west-2 --repository-name hmpps/spgw-alfresco-proxy --force
aws ecr delete-repository --region eu-west-2 --repository-name hmpps/spgw-ci-aws-cli --force
aws ecr delete-repository --region eu-west-2 --repository-name hmpps/spgw-ci-curl --force
aws ecr delete-repository --region eu-west-2 --repository-name hmpps/spgw-ci-ecs-deploy --force
aws ecr delete-repository --region eu-west-2 --repository-name hmpps/spgw-ci-gatling --force
aws ecr delete-repository --region eu-west-2 --repository-name hmpps/spgw-haproxy --force

