#!/bin/sh

set -e

# Usage
# Scripts takes 1 arguments environment_type
# TG_ENVIRONMENT_TYPE: target environment example dev prod

# Error handler function
exit_on_error() {
  exit_code=$1
  last_command=${@:2}
  if [ $exit_code -ne 0 ]; then
      >&2 echo "\"${last_command}\" command failed with exit code ${exit_code}."
      exit ${exit_code}
  fi
}

export TG_ENVIRONMENT_TYPE=$1

if [ -z "${TG_ENVIRONMENT_TYPE}" ]
then
    echo "configure_amazon_es.sh: TG_ENVIRONMENT_TYPE argument not supplied, please provide an argument!"
    exit 1
fi

case ${TG_ENVIRONMENT_TYPE} in
     delius-core-sandpit)
          export DNS_PREFIX=sandpit
          ;;
     *)
          export DNS_PREFIX=""
          ;;
esac

echo "TG_ENVIRONMENT_TYPE argument ${TG_ENVIRONMENT_TYPE}"
echo "DNS_PREFIX argument is ${DNS_PREFIX}"

echo "pwd is `pwd`"
echo "env variables are `set`"
echo "jenkins ip is `hostname -I`"

./add_index-pattern.sh ${TG_ENVIRONMENT_TYPE} ${DNS_PREFIX}
./add_template.sh ${TG_ENVIRONMENT_TYPE}  ${DNS_PREFIX}
#./add_pipeline.sh ${TG_ENVIRONMENT_TYPE}
#./add_search-tabular.sh ${TG_ENVIRONMENT_TYPE}
