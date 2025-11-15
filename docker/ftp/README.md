FTP Test Environment
====================

## Overview

This environment provides an FTP server for testing Fess FTP crawling capabilities.

## Start FTP Server

```bash
docker compose up -d --build
```

## Stop FTP Server

```bash
docker compose down
```

## FTP Server Information

- **Host**: localhost
- **Port**: 10021
- **Passive Ports**: 30000-30009
- **Username**: testuser1
- **Password**: test123

## Fess Configuration

### File Crawl Configuration

1. Download [Fess](https://github.com/codelibs/fess/releases)

2. Configure File Crawl Configuration with the following settings:

   | Name | Value |
   |:----:|:------|
   | Name | FTP Test |
   | Path | ftp://localhost:10021/ |
   | Parameter | client.enterLocalPassiveMode=true |

3. Configure File Authentication:

   | Field | Value |
   |:-----:|:------|
   | Username | testuser1 |
   | Password | test123 |

4. Start Crawl

## Manual FTP Access

You can test the FTP server manually:

```bash
ftp localhost 10021
# Username: testuser1
# Password: test123

ftp> passive
ftp> ls
ftp> cd upload
ftp> put testfile.txt
```

## Upload Test Files

To upload test files to the FTP server:

```bash
ftp localhost 10021
# Login with testuser1/test123
ftp> passive
ftp> prompt
ftp> lcd data
ftp> cd upload
ftp> mput *
```

## Notes

- The FTP server uses passive mode with ports 30000-30009
- Files uploaded to `/home/vsftpd/testuser1/upload/` are accessible for crawling
- The local `data` directory is mounted to the upload directory
