#!/usr/bin/env bash
set -e

source ${env_config_dir}/${environment_name}/${environment_name}.properties

terragrunt apply ${environment_name}.plan

