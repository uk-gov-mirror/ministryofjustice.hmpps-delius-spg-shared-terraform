#!/usr/bin/env bash
set -e


if ${ci_components_flag}  ; then
    source ${HMPPS_BUILD_WORK_DIR}/ci_env_configs/dev.properties
    cd ${HMPPS_BUILD_WORK_DIR}/ci-components/codepipeline
else
  source ${HMPPS_BUILD_WORK_DIR}/env_configs/${environment_name}/${environment_name}.properties
  cd ${HMPPS_BUILD_WORK_DIR}/${sub_project}
fi

/home/tools/data/scripts/2-stack-apply.sh

if ${ci_components_flag}  ; then
  ${HMPPS_BUILD_WORK_DIR}/scripts/disable-release-pipeline-stages.sh
fi