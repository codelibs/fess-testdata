#!/bin/bash

HOST=localhost:9201
INDEX=eslist_datastore
TYPE=failure_url
NUM=100
TMP_DIR=/tmp

curl -XDELETE $HOST/$INDEX?pretty

count=1
while [ $count -le $NUM ] ; do
    TMP_FILE=$TMP_DIR/testfile${count}.txt
    echo "Test Message $count" > $TMP_FILE
    curl -XPUT $HOST/$INDEX/$TYPE/$count?pretty -d '{"errorName":"java.lang.IllegalArgumentException","lastAccessTime":1449954723740,"configId":"123","errorLog":"Exception '$count': ...\n","errorCount":1,"threadName":"Crawler-'$count'","url":"file:'$TMP_FILE'"}'
    count=`expr $count + 1`
done

cat << EOF

#
# Crawling Config
#
<<Handler>>
EsListDataStore

<<Parameter>>
settings.cluster.name=elasticsearch
hosts=`echo $HOST|sed -e "s/9201/9301/"`
index=$INDEX
type=$TYPE
source={"query":{"term":{"errorName":{"value":"java.lang.IllegalArgumentException"}}}}
delete.processed.doc=true

<<Script>>
url=source.url
event_type="modify"

EOF
