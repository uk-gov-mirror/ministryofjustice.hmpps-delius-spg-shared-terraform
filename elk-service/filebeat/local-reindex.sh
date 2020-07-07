curl -k -XPOST "http://localhost:9200/_reindex" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "source": {
    "index": "spg-index-alias"
  },
  "dest": {
    "index": "spg-audit-7.1.1-repair"
  }
}
'
