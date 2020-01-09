#!/bin/sh

set -e

TG_ENVIRONMENT_TYPE=$1

if [ -z "${TG_ENVIRONMENT_TYPE}" ]
then
    echo "add_index-pattern.sh: TG_ENVIRONMENT_TYPE argument not supplied, please provide an argument!"
    exit 1
fi

echo "ping..."
ping amazones-audit.delius-core-sandpit.internal

echo "curl..."
curl -XPOST "https://amazones-audit.${TG_ENVIRONMENT_TYPE}.sandpit.probation.service.justice.gov.uk:443/_plugin/kibana/api/saved_objects/index-pattern/spg-audit" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
    "attributes": {
        "title": "spg-audit-7.1.1*",
        "timeFieldName": "@timestamp"
      }
}
'
