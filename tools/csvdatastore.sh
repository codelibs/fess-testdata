#!/bin/bash

NUM=1000
TMP_DIR=/tmp
CSV_DIR=$TMP_DIR/csv

mkdir -p $CSV_DIR

CSV_FILE=$CSV_DIR/data.csv
count=1
while [ $count -le $NUM ] ; do
    echo "$count,CsvDataStore $count,Test Message $count" >> $CSV_FILE
    count=`expr $count + 1`
done

cat << EOF

#
# Crawling Config
#
<<Handler>>
CsvDataStore

<<Parameter>>
directories=$CSV_DIR
fileEncoding=Shift_JIS

<<Script>>
url="http://localhost/" + cell1
host="localhost"
site="localhost"
title=cell2
content=cell3
cache=cell3
digest=cell3
anchor=
content_length=cell3.length()
last_modified=new java.util.Date()

EOF
