#!/usr/bin/env bash


docker run -it --rm \
    -v ${src_root_dir}:/home/tools/data \
    -v ~/.aws:/home/tools/.aws \
    -e AWS_PROFILE=hmpps-token \
    -e TF_LOG=INFO \
    -e HMPPS_BUILD_WORK_DIR=/home/tools/data \
    -e environment_name="${environment_name}" \
    -e LOCK_ID="${lockId}" \
    -e ENV_CONFIGS_DIR=/home/tools/data/env_configs \
    -e sub_project="${sub_project}" \
    -e "TERM=xterm-256color" \
    --entrypoint "scripts/${1}" \
    mojdigitalstudio/hmpps-terraform-builder-0-12:latest