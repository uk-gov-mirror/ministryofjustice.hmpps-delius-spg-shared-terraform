curl -XPOST "https://vpc-ndst-elk-audit-stack-6uwzfvrz5qzoi4hijmpepal5z4.eu-west-2.es.amazonaws.com:443/_plugin/kibana/api/saved_objects/search/spg-audit-tabular" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
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
