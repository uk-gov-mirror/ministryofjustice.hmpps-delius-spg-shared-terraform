curl -H 'Content-Type: application/json' -XGET 'https://vpc-ndst-elk-audit-stack-6uwzfvrz5qzoi4hijmpepal5z4.eu-west-2.es.amazonaws.com:443/filebeat*'

curl -k -H 'Content-Type: application/json' -XGET 'https://amazones-audit.delius-core-sandpit.internal:443/spg-audit-7.1.1-2020.05.14/_search?pretty' -d'
{
    "query": {
        "match_all": {}
    }
}'
