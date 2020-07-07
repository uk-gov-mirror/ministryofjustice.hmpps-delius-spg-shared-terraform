curl -k -XPOST "http://localhost:9200/_aliases" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
    "actions" : [
        { "add" : { "index" : "spg-audit-7.1.1*", "alias" : "spg-index-alias" } }
    ]
}
'
