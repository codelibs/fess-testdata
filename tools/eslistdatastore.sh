#!/bin/bash

HOST=localhost:9201
INDEX=eslist_datastore
TYPE=_doc
NUM=100
TMP_DIR=/tmp

curl -XDELETE -H "Content-Type: application/json" $HOST/$INDEX?pretty
curl -XPOST -H "Content-Type: application/json" $HOST/_refresh?pretty
curl -XPUT -H "Content-Type: application/json" $HOST/$INDEX?pretty -d '{"mappings":{"properties":{"configId":{"type":"keyword"},"errorCount":{"type":"long"},"errorLog":{"type":"text"},"errorName":{"type":"text"},"lastAccessTime":{"type":"long"},"threadName":{"type":"text"},"url":{"type":"keyword"}}},"settings":{"index":{"number_of_shards":"1","number_of_replicas":"0"}}}'

count=1
while [ $count -le $NUM ] ; do
    TMP_FILE=$TMP_DIR/testfile${count}.txt
    echo "Test Message $count" > $TMP_FILE
    curl -XPUT -H "Content-Type: application/json" $HOST/$INDEX/$TYPE/$count?pretty -d '{"errorName":"java.lang.IllegalArgumentException","lastAccessTime":1449954723740,"configId":"123","errorLog":"Exception '$count': ...\n","errorCount":1,"threadName":"Crawler-'$count'","url":"file:'$TMP_FILE'"}'
    count=`expr $count + 1`
done

cat << EOF

#
# Crawling Config
#
<<Handler>>
EsListDataStore

<<Parameter>>
settings.http.hosts=`echo $HOST`
index=$INDEX
source={"query":{"term":{"errorName":{"value":"java.lang.IllegalArgumentException"}}}}
delete.processed.doc=true

<<Script>>
url=source.url
event_type="modify"

EOF
