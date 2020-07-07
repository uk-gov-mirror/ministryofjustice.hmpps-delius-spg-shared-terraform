curl -k -XDELETE "http://localhost:5601/api/saved_objects/index-pattern/spg-audit" -H 'kbn-xsrf: true' -H 'Content-Type: application/json'
curl -k -XDELETE "http://localhost:5601/api/saved_objects/search/spg-audit-tabular" -H 'kbn-xsrf: true' -H 'Content-Type: application/json'
curl -k -H 'Content-Type: application/json' -XDELETE 'http://localhost:9200/spg-audit*'
curl -k -H 'Content-Type: application/json' -XDELETE 'http://localhost:9200/_ingest/pipeline/spg-audit'
curl -k -XDELETE "http://localhost:9200/_template/spg-audit" -H 'Content-Type: application/json'

