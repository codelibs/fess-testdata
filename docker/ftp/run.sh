#!/bin/bash

cd `dirname $0`

cat <<EOS
Name: Test

Path:
ftp://localhost:10021/

Parameter:
client.enterLocalPassiveMode=true

Authentication:
Username: testuser1
Password: test123

Starting FTP Docker...
EOS

docker build -t fess-vsftpd .
docker run -d --name ftp-server \
  -p 10021:21 \
  -p 30000-30009:30000-30009 \
  fess-vsftpd

if [ $? = 0 ] ; then
  cat <<EOS
Example:
$ ftp localhost 10021
Name (localhost:shinsuke): testuser1
Password: test123
ftp> passive
ftp> prompt
ftp> lcd data
ftp> cd upload
ftp> mput *

Cleanup:
docker stop ftp-server
docker rm ftp-server
EOS
fi
