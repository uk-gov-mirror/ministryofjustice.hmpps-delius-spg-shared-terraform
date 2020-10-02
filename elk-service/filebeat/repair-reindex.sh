# To reduce the number of consecutive indexes you can add a partial date to the
# source and dest index field
# e.g. "spg-audit-7.1.1-2020-09-*"
# if you do amend the source you need to make the same change to the dest
# It is also possible to add a batch size to the "source" element
#
#"source": {
#    "index": "source",
#    "size": 100
#  },
#
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
