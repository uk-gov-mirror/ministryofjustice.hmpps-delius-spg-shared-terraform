#!/usr/bin/env bash
set -e

source ${HMPPS_BUILD_WORK_DIR}/env_configs/${environment_name}/${environment_name}.properties

cd ${HMPPS_BUILD_WORK_DIR}/${sub_project}
/home/tools/data/scripts/2-stack-apply.sh