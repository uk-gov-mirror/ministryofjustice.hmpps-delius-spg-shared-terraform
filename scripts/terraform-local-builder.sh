#!/usr/bin/env bash

docker run -it --rm \
    -v ${src_root_dir}:/home/tools/data \
    -v ~/.aws:/home/tools/.aws \
    -e AWS_PROFILE=hmpps-token \
    -e TF_LOG=INFO \
    -e HMPPS_BUILD_WORK_DIR=/home/tools/data \
    -e environment_name="${environment_name}" \
    -e TF_VAR_action_types="${action_types}" \
    -e LOCK_ID="${lockId}" \
    -e ENV_CONFIGS_DIR=/home/tools/data/env_configs \
    -e sub_project="${sub_project}" \
    -e ci_components_flag=${ci_components_flag} \
    -e "TERM=xterm-256color" \
    --entrypoint "scripts/${1}" \
    895523100917.dkr.ecr.eu-west-2.amazonaws.com/hmpps/terraform-builder-0-12:latest