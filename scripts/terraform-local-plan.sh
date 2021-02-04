#!/usr/bin/env bash
set -e


if ${ci_components_flag}  ; then
    source ${HMPPS_BUILD_WORK_DIR}/ci_env_configs/dev.properties
    cd ${HMPPS_BUILD_WORK_DIR}/ci-components/codepipeline
else
    rm -rf ${ENV_CONFIGS_DIR}
    git clone https://github.com/ministryofjustice/hmpps-env-configs.git ${ENV_CONFIGS_DIR}

    source ${HMPPS_BUILD_WORK_DIR}/env_configs/${environment_name}/${environment_name}.properties

    cd ${HMPPS_BUILD_WORK_DIR}/${sub_project}
fi

/home/tools/data/scripts/1-stack-plan.sh