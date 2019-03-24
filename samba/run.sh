#!/bin/bash

cd `dirname $0`

cat <<EOS
Name: Test

Path:
smb://localhost/public/
smb1://localhost/public/

Starting Samba Docker...
EOS

if [ x"$USE_SMB1" != "xfalse" ] ; then
  SMB_OPTIONS="$SMB_OPTIONS -S"
fi

rm -rf data
mkdir data
cp -r ../docuworks ../ichitaro ../msoffice ../other ../source_code ../xml ../autocad ../pdf ../text ../archive ../html data

docker run -it -p 139:139 -p 445:445 -v `pwd`/data:/share dperson/samba $SMB_OPTIONS \
            -u "testuser1;test123" \
            -u "testuser2;test123" \
            -s "public;/share" \
            -s "users;/srv;no;no;no;testuser1,testuser2" \
            -s "testuser1 private share;/testuser1;no;no;no;testuser1" \
            -s "testuser2 private share;/testuser2;no;no;no;testuser2"
