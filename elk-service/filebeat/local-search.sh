curl -k -XPOST "http://localhost:5601/api/saved_objects/search/spg-audit-tabular" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
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
          "interchangeTimestamp",
          "desc"
        ],
        "version" : 1,
        "kibanaSavedObjectMeta" : {
              "searchSourceJSON" : "{\"highlightAll\":true,\"version\":true,\"query\":{\"language\":\"kuery\",\"query\":\"\"},\"filter\":[],\"index\":\"spg-audit\"}"
        }
    }
}
'
