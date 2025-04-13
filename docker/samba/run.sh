#!/bin/bash

cd `dirname $0`

cat <<EOS
Name: Test

Path:
smb://localhost:1139/public/
smb1://localhost:1139/public/
smb://localhost:1139/users/
smb1://localhost:1139/users/

Authentication:
Username: testuser1 or testuser2
Password: test123

Starting Samba Docker...
EOS

if [ x"$USE_SMB1" != "xfalse" ] ; then
  SMB_OPTIONS="$SMB_OPTIONS -S"
fi

rm -rf data
mkdir -p data/share data/users
for f in $(find ../../docuworks ../../ichitaro ../../msoffice ../../other ../../source_code ../../xml ../../autocad ../../pdf ../../text ../../archive ../../html -type f) ; do
  cp $f data/share/share_$(basename $f)
  cp $f data/users/users_$(basename $f)
done
exit

docker run -it -p 1139:139 -p 1445:445 -v `pwd`/data:/share dperson/samba $SMB_OPTIONS \
            -u "testuser1;test123" \
            -u "testuser2;test123" \
            -s "public;/share" \
            -s "users;/users;no;no;no;testuser1,testuser2" \
            -s "testuser1 private share;/testuser1;no;no;no;testuser1" \
            -s "testuser2 private share;/testuser2;no;no;no;testuser2"
