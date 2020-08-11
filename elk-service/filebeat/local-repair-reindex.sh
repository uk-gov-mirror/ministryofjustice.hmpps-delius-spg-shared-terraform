#"source": "ctx._index = ctx._index + \u0027-repair\u0027"
#"source": "ctx._index = \u0027spg-audit-7.1.1-repair-\u0027 +  (ctx._index.substring(\u0027spg-audit-7.1.1-\u0027.length(), ctx._index.length()))"
curl -k -H 'Content-Type: application/json' -XPOST "http://localhost:9200/_reindex?pretty" -d'
{
  "source": {
    "index": "spg-audit-7.1.1-*"
  },
  "dest": {
    "index": "repair-spg-audit-7.1.1-"
  },
  "script": {
    "lang": "painless",
    "source": "ctx._index = \u0027repair-\u0027 +  ctx._index"
  }
}
'
