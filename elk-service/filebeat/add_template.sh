export TG_ENVIRONMENT_TYPE=$1
export DNS_PREXIX=$2

if [ -z "${TG_ENVIRONMENT_TYPE}" ]
then
    echo "add_template.sh: TG_ENVIRONMENT_TYPE argument not supplied, please provide an argument!"
    exit 1
fi

if [ -z "${DNS_PREFIX}" ]
then
  export URL="https://amazones-audit.probation.service.justice.gov.uk"
else
  export URL="https://amazones-audit.${DNS_PREFIX}.probation.service.justice.gov.uk"
fi

curl -k -XPUT "${URL}:443/_template/spg-audit" -H "Content-Type: application/json" -d@spg-audit-template.json
