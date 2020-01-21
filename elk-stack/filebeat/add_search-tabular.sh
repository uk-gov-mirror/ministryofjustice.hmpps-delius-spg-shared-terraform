export TG_ENVIRONMENT_TYPE=$1
export DNS_PREXIX=$2

if [ -z "${TG_ENVIRONMENT_TYPE}" ]
then
    echo "add_search-tabular.sh: TG_ENVIRONMENT_TYPE argument not supplied, please provide an argument!"
    exit 1
fi

if [ -z "${DNS_PREFIX}" ]
then
    echo "add_search-tabular.sh: DNS_PREFIX argument not supplied, please provide an argument!"
    exit 1
fi

curl -k -XPOST "https://amazones-audit.${TG_ENVIRONMENT_TYPE}.${DNS_PREFIX}.probation.service.justice.gov.uk:443/_plugin/kibana/api/saved_objects/search/spg-audit-tabular" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
    "attributes" : {
        "title": "SPG: Latest Tabular View",
        "description" : "",
        "hits" : 0,
        "columns": [
          "from",
          "to",
          "caseReferenceNumber",
          "logType",
          "senderControlRef",
          "receiverControlRef",
          "messageVersionNumber",
          "messageNotificationStatusCode"
        ],
        "sort": [
          "@timestamp",
          "desc"
        ],
        "version" : 1,
        "kibanaSavedObjectMeta" : {
              "searchSourceJSON" : "{\"highlightAll\":true,\"version\":true,\"query\":{\"language\":\"kuery\",\"query\":\"\"},\"filter\":[],\"index\":\"spg-audit\"}"
        }
    }
}
'
