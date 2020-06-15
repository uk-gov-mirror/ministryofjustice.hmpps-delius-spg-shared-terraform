# Need the id of the index-pattern to delete it
curl -k -XDELETE "https://vpc-ndst-elk-audit-stack-6uwzfvrz5qzoi4hijmpepal5z4.eu-west-2.es.amazonaws.com:443/_plugin/kibana/api/saved_objects/index-pattern/spg-audit" -H 'kbn-xsrf: true' -H 'Content-Type: application/json'

