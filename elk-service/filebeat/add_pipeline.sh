export TG_ENVIRONMENT_TYPE=$1
export DNS_PREXIX=$2

if [ -z "${TG_ENVIRONMENT_TYPE}" ]
then
    echo "add_pipeline.sh: TG_ENVIRONMENT_TYPE argument not supplied, please provide an argument!"
    exit 1
fi

if [ -z "${DNS_PREFIX}" ]
then
  export URL="https://amazones-audit.probation.service.justice.gov.uk"
else
  export URL="https://amazones-audit.${DNS_PREFIX}.probation.service.justice.gov.uk"
fi

curl -k -H 'Content-Type: application/json' -XPUT "${URL}:443/_ingest/pipeline/spg-audit" -d@spg-audit-pipeline.json
