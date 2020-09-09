#{ "remove" : { "index" : "spg-audit-7.1.1-repair", "alias" : "spg-index-alias" } }
curl -k -XPOST "http://localhost:9200/_aliases" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
    "actions" : [
        { "add" : { "index" : "spg-audit-7.1.1-2020*", "alias" : "spg-index-alias" } }
    ]
}
'
