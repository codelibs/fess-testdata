LDAP Testing Environment
=============

## Overview

TBD

### Start LDAP Sever and phpMyAdmin

```
$ docker-compose up
```

### Import Data

i. Open phpMyAdmin: `http://localhost:8081`
1. Login `cn=admin,dc=fess,dc=codelibs,dc=org`/`admin` as username/password
1. Import `fess_codelibs_org.ldif`

### Start Fess

TBD

### LDAPS

To check SSL configuration, you can use [SSLPoke.class](https://ja.confluence.atlassian.com/kb/files/779355358/779355357/1/1441897666313/SSLPoke.class).

```
$ openssl s_client -connect localhost:636 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ldaps.cer
$ mkdir keystores
$ keytool -import -file ldaps.cer -alias ldaps -keystore keystores/ldaps.jks -storepass changeit
$ java -Djavax.net.ssl.trustStore=keystores/ldaps.jks -Djavax.net.ssl.trustStorePassword=changeit -Djavax.net.debug=ssl,handshake SSLPoke localhost 636
```


