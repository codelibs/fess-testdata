#!/bin/bash

NUM=100
TMP_DIR=/tmp
CSV_DIR=$TMP_DIR/csvlist

mkdir -p $CSV_DIR

CSV_FILE=$CSV_DIR/data.csv
count=1
while [ $count -le $NUM ] ; do
    TMP_FILE=$TMP_DIR/testfile${count}.txt
    echo "Test Message $count" > $TMP_FILE
    echo "modify,file:$TMP_FILE" >> $CSV_FILE
    count=`expr $count + 1`
done

cat << EOF

#
# Crawling Config
#
<<Handler>>
CsvListDataStore

<<Parameter>>
directories=$CSV_DIR
fileEncoding=Shift_JIS

<<Script>>
event_type=cell1
url=cell2

EOF
