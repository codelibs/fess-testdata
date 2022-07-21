#!/bin/bash

NUM=1000
TMP_DIR=/tmp
CSV_DIR=$TMP_DIR/csv

mkdir -p $CSV_DIR

CSV_FILE=$CSV_DIR/data.csv
rm $CSV_FILE
echo "1,testuser1,Test User 1,1testuser1" >> $CSV_FILE
echo "2,testuser2,Test User 2,1testuser2" >> $CSV_FILE
echo "3,testuser3,Test User 3,1testuser3" >> $CSV_FILE
echo "4,group1,Test Group 1,2group1" >> $CSV_FILE
echo "5,group2,Test Group 2,2group2" >> $CSV_FILE
echo "6,group3,Test Group 3,2group3" >> $CSV_FILE
echo "7,role1,Test Role 1,Rrole1" >> $CSV_FILE
echo "8,role2,Test Role 2,Rrole2" >> $CSV_FILE
echo "9,role3,Test Role 3,Rrole3" >> $CSV_FILE

BULK_FILE=$TMP_DIR/fess_data.bulk
cat << EOF > $BULK_FILE
{"index":{"_index":"fess_config.access_token","_id":"uroOHoIBVy8iTvyuIX7x"}}
{"updatedTime":0,"updatedBy":"admin","createdBy":"admin","permissions":[],"name":"Test Token","createdTime":0,"parameter_name":"permissions","token":"TOKEN"}
{"index":{"_index":"fess_config.data_config","_id":"XrrwHYIBVy8iTvyuL34f"}}
{"updatedTime":0,"virtualHosts":[],"updatedBy":"admin","available":true,"handlerName":"CsvDataStore","handlerParameter":"directories=$CSV_DIR\nfileEncoding=UTF-8","handlerScript":"url=\"http://localhost/\" + cell1\nhost=\"localhost\"\nsite=\"localhost\"\ntitle=cell2\ncontent=cell3\ncache=cell3\ndigest=cell3\nanchor=\ncontent_length=cell3.length()\nlast_modified=new java.util.Date()\nrole=[cell4]","createdBy":"admin","permissions":[],"sortOrder":0,"name":"Test","createdTime":0,"boost":1.0}
{"index":{"_index":"fess_user.group","_id":"Z3JvdXAx"}}
{"name":"group1","gidNumber":"1"}
{"index":{"_index":"fess_user.group","_id":"Z3JvdXAy"}}
{"name":"group2","gidNumber":"2"}
{"index":{"_index":"fess_user.group","_id":"Z3JvdXAz"}}
{"name":"group3","gidNumber":"3"}
{"index":{"_index":"fess_user.role","_id":"cm9sZTE="}}
{"name":"role1"}
{"index":{"_index":"fess_user.role","_id":"cm9sZTI="}}
{"name":"role2"}
{"index":{"_index":"fess_user.role","_id":"cm9sZTM="}}
{"name":"role3"}
{"index":{"_index":"fess_user.user","_id":"dGVzdHVzZXIx"}}
{"password":"ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae","mail":"","surname":"","givenName":"","name":"testuser1"}
{"index":{"_index":"fess_user.user","_id":"dGVzdHVzZXIy"}}
{"password":"ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae","mail":"","surname":"","roles":["cm9sZTI="],"givenName":"","name":"testuser2"}
{"index":{"_index":"fess_user.user","_id":"dGVzdHVzZXIz"}}
{"password":"ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae","mail":"","surname":"","givenName":"","name":"testuser3","groups":["Z3JvdXAz"]}
EOF

echo "Upload $BULK_FILE"
echo
cat << EOL
curl -H "Authorization: TOKEN" "localhost:8080/json/?q=*:*&permissions=1testuser1"
curl -H "Authorization: TOKEN" "localhost:8080/json/?q=*:*&permissions=1testuser2"
curl -H "Authorization: TOKEN" "localhost:8080/json/?q=*:*&permissions=1testuser3"
curl -H "Authorization: TOKEN" "localhost:8080/json/?q=*:*&permissions=2group1"
curl -H "Authorization: TOKEN" "localhost:8080/json/?q=*:*&permissions=2group2"
curl -H "Authorization: TOKEN" "localhost:8080/json/?q=*:*&permissions=2group3"
curl -H "Authorization: TOKEN" "localhost:8080/json/?q=*:*&permissions=Rrole1"
curl -H "Authorization: TOKEN" "localhost:8080/json/?q=*:*&permissions=Rrole2"
curl -H "Authorization: TOKEN" "localhost:8080/json/?q=*:*&permissions=Rrole3"
EOL
