#!/usr/bin/env bash

set -ex

rm -rf ${ENV_CONFIGS_DIR}
git clone https://github.com/ministryofjustice/hmpps-env-configs.git ${ENV_CONFIGS_DIR}

source ${HMPPS_BUILD_WORK_DIR}/env_configs/${environment_name}/${environment_name}.properties

cd ${HMPPS_BUILD_WORK_DIR}/${sub_project}

/home/tools/data/scripts/stack-unlock.sh