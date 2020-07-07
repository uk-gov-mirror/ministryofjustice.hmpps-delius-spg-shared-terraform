curl -k -XPOST "http://localhost:9200/_reindex" -H 'Content-Type: application/json' -d'
{
  "source": {
    "index": "spg-audit-7*"
  },
  "dest": {
    "index": "spg-audit-7"
  },
  "script": {
    "lang": "painless",
    "source": "ctx[_index] = \"repair-\" + ctx[_index]"
  }
}
'
