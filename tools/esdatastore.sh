#!/bin/bash

HOST=localhost:9201
INDEX=es_datastore
TYPE=_doc
NUM=1000

curl -XDELETE -H "Content-Type: application/json" $HOST/$INDEX?pretty
curl -XPOST -H "Content-Type: application/json" $HOST/_refresh?pretty
curl -XPUT -H "Content-Type: application/json" $HOST/$INDEX?pretty -d '{"mappings":{"properties":{"content":{"type":"text"},"size":{"type":"long"},"title":{"type":"text"},"url":{"type":"keyword"}}},"settings":{"index":{"number_of_shards":"1","number_of_replicas":"0"}}}}'

count=1
while [ $count -le $NUM ] ; do
    curl -XPUT -H "Content-Type: application/json" $HOST/$INDEX/$TYPE/$count?pretty -d '{"title":"ESDataStore '$count'","content":"Test Message '$count'","url":"http://'$HOST'/'$INDEX'/'$TYPE'/'$count'","size":100}'
    count=`expr $count + 1`
done

cat << EOF
#
# Crawling Config
#
<<Handler>>
EsDataStore

<<Parameter>>
settings.http.hosts=`echo $HOST`
index=$INDEX
delete.processed.doc=true

<<Script>>
url=source.url
host="localhost"
site="localhost"
title=source.title
content=source.content
digest=
anchor=
content_length=source.size
last_modified=new java.util.Date()

EOF

