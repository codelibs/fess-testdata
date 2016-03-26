#!/bin/bash

HOST=localhost:9201
INDEX=es_datastore
TYPE=doc
NUM=1000

curl -XDELETE $HOST/$INDEX?pretty

count=1
while [ $count -le $NUM ] ; do
    curl -XPUT $HOST/$INDEX/$TYPE/$count?pretty -d '{"title":"ESDataStore '$count'","content":"Test Message '$count'","url":"http://'$HOST'/'$INDEX'/'$TYPE'/'$count'","size":100}'
    count=`expr $count + 1`
done

cat << EOF
#
# Crawling Config
#
<<Handler>>
EsDataStore

<<Parameter>>
settings.cluster.name=elasticsearch
hosts=`echo $HOST|sed -e "s/9201/9301/"`
index=$INDEX
type=$TYPE
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

