#!/bin/sh

set -e

export TG_ENVIRONMENT_TYPE=$1
export DNS_PREXIX=$2

if [ -z "${TG_ENVIRONMENT_TYPE}" ]
then
    echo "add_index-pattern.sh: TG_ENVIRONMENT_TYPE argument not supplied, please provide an argument!"
    exit 1
fi

if [ -z "${DNS_PREFIX}" ]
then
    echo "add_index-pattern.sh: DNS_PREFIX argument not supplied, please provide an argument!"
    exit 1
fi

curl -k -XPOST "https://amazones-audit.${DNS_PREFIX}.probation.service.justice.gov.uk:443/_plugin/kibana/api/saved_objects/index-pattern/spg-audit" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
    "attributes": {
        "title": "spg-audit-7.1.1*",
        "timeFieldName": "@timestamp"
      }
}
'
