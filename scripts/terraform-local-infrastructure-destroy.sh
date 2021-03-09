#!/usr/bin/env bash
set -e

subproject=(ecs-crc ecs-mpx ecs-iso elk-service elk-domains iam-spg-app-policies kms-certificates-spg amazonmq dynamodb-sequence-generator psn-proxy-route-53 iam security-groups-and-rules common)

rm -rf ${ENV_CONFIGS_DIR}
git clone https://github.com/ministryofjustice/hmpps-env-configs.git ${ENV_CONFIGS_DIR}
source ${HMPPS_BUILD_WORK_DIR}/env_configs/${environment_name}/${environment_name}.properties

env | sort

# Loop trough all SPG modules and run terragrunt destroy
for sub_project in "${subproject[@]}"
do
   :
  cd ${HMPPS_BUILD_WORK_DIR}/$sub_project

  if [ -d .terraform ]; then
    rm -rf .terraform
  fi
  terragrunt refresh
  sleep 1
  terragrunt destroy
done

set +e
