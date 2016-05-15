#!/bin/bash

MIN_LAT=35
MAX_LAT=35
MIN_LON=139
MAX_LON=139

#MIN_LAT=-1
#MAX_LAT=1
#MIN_LON=-1
#MAX_LON=1

TMP_DIR=/tmp
CSV_DIR=$TMP_DIR/csv

mkdir -p $CSV_DIR

CSV_FILE=$CSV_DIR/data.csv
lat_count=$MIN_LAT
while [ $lat_count -le $MAX_LAT ] ; do
    lon_count=$MIN_LON
    while [ $lon_count -le $MAX_LON ] ; do
        count=0
        while [ $count -lt 1000 ] ; do
            lat=`printf "%d.%03d" $lat_count $count`
            lon=`printf "%d.%03d" $lon_count $count`
            echo "\"${lat},${lon}\",\"GEO ${lat_count}:${lon}\",\"Test Message lat:$lat lon:$lon\"" >> $CSV_FILE
            count=`expr $count + 1`
        done
        lon_count=`expr $lon_count + 1`
    done
    lat_count=`expr $lat_count + 1`
done

cat << EOF

#
# Crawling Config
#
<<Handler>>
CsvDataStore

<<Parameter>>
directories=$CSV_DIR
fileEncoding=UTF-8
quoteDisabled=false

<<Script>>
url="https://www.google.com/search?q=" + cell1
host="localhost"
site="localhost"
title=cell2
content=cell3
cache=cell3
digest=cell3
anchor=
content_length=cell3.length()
last_modified=new java.util.Date()
location=cell1

EOF
