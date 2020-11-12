#!/usr/bin/env bash
set -e

source ${env_config_dir}/${environment_name}/${environment_name}.properties

    if [ -d .terraform ]; then
        rm -rf .terraform
    fi
    rm -f ${environment_name}.plan
    sleep 1
    terragrunt init
    terragrunt refresh
    terragrunt fmt
    terragrunt plan --out ${environment_name}.plan

set +e