#!/usr/bin/env bash
set -e

export environment_name="${1}"
export sub_project="${2:-"unknown"}"
export src_root_dir=$(pwd)
export ci_components_flag=${4:-false}
export action_types='["plan","apply"]'

if "$ci_components_flag"  ; then
  $(pwd)/scripts/clone-engineering-platform-env-configs.sh
fi


$(pwd)/scripts/terraform-local-builder.sh terraform-local-${3}.sh
