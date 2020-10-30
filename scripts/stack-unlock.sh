#!/usr/bin/env bash
set -e

    if [ -d .terraform ]; then
        rm -rf .terraform
    fi
    sleep 1
    terragrunt force-unlock ${LOCK_ID}

set +e