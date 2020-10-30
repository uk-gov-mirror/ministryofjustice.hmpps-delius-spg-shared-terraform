#!/usr/bin/env bash
set -e

terragrunt apply ${environment_name}.plan

