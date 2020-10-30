#!/usr/bin/env bash
set -e

export environment_name="${1}"
export sub_project="${2}"
export src_root_dir=$(pwd)

$(pwd)/scripts/terraform-local-builder.sh terraform-local-${3}.sh
