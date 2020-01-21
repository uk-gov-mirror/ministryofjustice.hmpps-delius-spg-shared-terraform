export TG_ENVIRONMENT_TYPE=$1
export DNS_PREXIX=$2

if [ -z "${TG_ENVIRONMENT_TYPE}" ]
then
    echo "add_template.sh: TG_ENVIRONMENT_TYPE argument not supplied, please provide an argument!"
    exit 1
fi

if [ -z "${DNS_PREFIX}" ]
then
    echo "add_template.sh: DNS_PREFIX argument not supplied, please provide an argument!"
    exit 1
fi

curl -k -XPUT "https://amazones-audit.${TG_ENVIRONMENT_TYPE}.${DNS_PREFIX}.probation.service.justice.gov.uk:443/_template/spg-audit" -H "Content-Type: application/json" -d@spg-audit-template.json
