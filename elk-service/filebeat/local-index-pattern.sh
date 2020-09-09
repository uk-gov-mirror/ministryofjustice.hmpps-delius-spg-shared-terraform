curl -k -XPOST "http://localhost:5601/api/saved_objects/index-pattern/spg-audit" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
    "attributes": {
        "title": "spg-audit-7.1.1*",
        "timeFieldName": "interchangeTimestamp"
      }
}
'
