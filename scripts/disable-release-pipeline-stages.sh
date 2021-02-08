#!/usr/bin/env bash
set -e

## Assume eng role
source ${HMPPS_BUILD_WORK_DIR}/scripts/assume-eng-role.sh

# Get the pipeline name from ssm store
pipeline_name=$(aws ssm get-parameter --region eu-west-2 --name /codepipeline/spg/pipeline_name --query "Parameter.Value" | tr -d '"')

# Disable release pipeline stages
aws codepipeline  disable-stage-transition \
--pipeline-name delius-spgw-legacy-spg-infrastructure-release-${pipeline_name} \
--stage-name Source \
--region eu-west-2 \
--transition-type Outbound \
--reason "Stop release pipeline execution"