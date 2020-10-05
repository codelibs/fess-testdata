#!/bin/bash

PASSPHRASE=$1
ROLES=$2

PP_FILE=/tmp/passphrase.$$
IN_FILE=/tmp/inputfile.$$
OUT_FILE=/tmp/outputfile.$$

echo $PASSPHRASE > $PP_FILE
echo `date '+%s'`"\n$ROLES" > $IN_FILE
openssl enc -base64 -e -bf-cbc -in $IN_FILE -out $OUT_FILE -kfile $PP_FILE
echo -n "Encrypted Roles: "
cat $OUT_FILE
rm $PP_FILE $IN_FILE $OUT_FILE
