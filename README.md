# Test Data Repository for Search Systems

## Overview

A repository of test data for verifying whether search systems can crawl and index various file types.
Feel free to submit a pull request if you have files you want to test.

## Directory Structure

```
fess-testdata/
├── files/          # Test data files
├── docker/         # Docker configurations for crawling environments
├── tools/          # Utility scripts
└── build/          # Build-related files
```

## How to Create Test Files

### File Naming

Add the prefix "test" and use the appropriate file extension.

### File Content

Include the text "Lorem ipsum. (ロレム・イプサム) 吾輩は猫である。" in the content section of the file.
Do not include this text in metadata sections (to clearly identify where content was extracted from).

### Directory

Place files in the appropriate category directory under `files/`.

## Test Data Files

### Documents

| Type | Location |
|:----:|:-----------|
|Text|[files/text/test_utf8.txt](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/text/test_utf8.txt)|
|HTML|[files/html/test.html](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/html/test.html)|
|HTML|[files/html/test_utf8.html](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/html/test_utf8.html)|
|HTML|[files/html/test_sjis.html](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/html/test_sjis.html)|
|HTML|[files/html/test_hankaku.html](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/html/test_hankaku.html)|
|HTML|[files/html/test_nocharset.html](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/html/test_nocharset.html)|
|XML|[files/xml/test_utf8.xml](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/xml/test_utf8.xml)|
|XML|[files/xml/test_sjis.xml](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/xml/test_sjis.xml)|
|XML|[files/xml/test_entity.xml](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/xml/test_entity.xml)|
|XML|[files/xml/test.mm](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/xml/test.mm)|
|PDF|[files/pdf/test.pdf](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/pdf/test.pdf)|
|PDF|[files/pdf/test.ps](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/pdf/test.ps)|
|Markdown|[files/markdown/test.md](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/markdown/test.md)|
|AsciiDoc|[files/markdown/test.adoc](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/markdown/test.adoc)|
|reStructuredText|[files/markdown/test.rst](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/markdown/test.rst)|
|LaTeX|[files/latex/test.tex](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/latex/test.tex)|
|EPUB|[files/ebook/test.epub](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/ebook/test.epub)|
|CHM|[files/help/test.chm](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/help/test.chm)|

### Office Documents

| Type | Location |
|:----:|:-----------|
|MS Word|[files/msoffice/test.doc](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/msoffice/test.doc)|
|MS Word|[files/msoffice/test.docx](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/msoffice/test.docx)|
|MS Excel|[files/msoffice/test.xls](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/msoffice/test.xls)|
|MS Excel|[files/msoffice/test.xlsx](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/msoffice/test.xlsx)|
|MS PowerPoint|[files/msoffice/test.ppt](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/msoffice/test.ppt)|
|MS PowerPoint|[files/msoffice/test.pptx](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/msoffice/test.pptx)|
|MS Visio|[files/msoffice/test.vsdx](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/msoffice/test.vsdx)|
|MS Project|[files/msoffice/test.mpp](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/msoffice/test.mpp)|
|MS Publisher|[files/msoffice/test.pub](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/msoffice/test.pub)|
|RTF|[files/msoffice/test.rtf](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/msoffice/test.rtf)|
|OpenDocument Text|[files/opendocument/test.odt](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/opendocument/test.odt)|
|OpenDocument Spreadsheet|[files/opendocument/test.ods](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/opendocument/test.ods)|
|OpenDocument Presentation|[files/opendocument/test.odp](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/opendocument/test.odp)|
|Apple Pages|[files/iwork/test.pages](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/iwork/test.pages)|
|Apple Numbers|[files/iwork/test.numbers](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/iwork/test.numbers)|
|Apple Keynote|[files/iwork/test.key](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/iwork/test.key)|
|Lotus 1-2-3|[files/lotus/test.123](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/lotus/test.123)|
|Hancom|[files/hancom/test.hwp](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/hancom/test.hwp)|
|Ichitaro|files/ichitaro/|
|DocuWorks|files/docuworks/|

### Database

| Type | Location |
|:----:|:-----------|
|MS Access|[files/database/test.accdb](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/database/test.accdb)|
|MS Access (Legacy)|[files/database/test.mdb](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/database/test.mdb)|
|FileMaker|[files/database/test.fmp12](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/database/test.fmp12)|
|dBase|[files/database/test.dbf](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/database/test.dbf)|

### Media & Images

| Type | Location |
|:----:|:-----------|
|PNG|[files/images/test.png](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/images/test.png)|
|JPEG|[files/images/test.jpg](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/images/test.jpg)|
|GIF|[files/images/test.gif](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/images/test.gif)|
|BMP|[files/images/test.bmp](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/images/test.bmp)|
|TIFF|[files/images/test.tiff](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/images/test.tiff)|
|SVG|[files/images/test.svg](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/images/test.svg)|
|MP3|[files/media/test.mp3](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/media/test.mp3)|

### Source Code

| Type | Location |
|:----:|:-----------|
|C|[files/source_code/test.c](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/source_code/test.c)|
|C++|[files/source_code/test.cpp](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/source_code/test.cpp)|
|Java|[files/source_code/test.java](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/source_code/test.java)|
|JavaScript|[files/source_code/test.js](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/source_code/test.js)|
|TypeScript|[files/source_code/test.ts](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/source_code/test.ts)|
|Python|[files/source_code/test.py](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/source_code/test.py)|
|Ruby|[files/source_code/test.rb](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/source_code/test.rb)|
|Go|[files/source_code/test.go](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/source_code/test.go)|
|Rust|[files/source_code/test.rs](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/source_code/test.rs)|
|Swift|[files/source_code/test.swift](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/source_code/test.swift)|
|Kotlin|[files/source_code/test.kt](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/source_code/test.kt)|
|PHP|[files/source_code/test.php](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/source_code/test.php)|
|SQL|[files/source_code/test.sql](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/source_code/test.sql)|
|CSS|[files/source_code/test.css](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/source_code/test.css)|
|SCSS|[files/source_code/test.scss](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/source_code/test.scss)|

### Scripts & Configuration

| Type | Location |
|:----:|:-----------|
|Bash|[files/scripts/test.bash](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/scripts/test.bash)|
|Perl|[files/scripts/test.pl](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/scripts/test.pl)|
|Lua|[files/scripts/test.lua](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/scripts/test.lua)|
|PowerShell|[files/scripts/test.ps1](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/scripts/test.ps1)|
|JSON|[files/config/test.json](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/config/test.json)|
|YAML|[files/config/test.yaml](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/config/test.yaml)|
|TOML|[files/config/test.toml](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/config/test.toml)|
|INI|[files/config/test.ini](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/config/test.ini)|
|Properties|[files/config/test.properties](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/config/test.properties)|

### Archives

| Type | Location |
|:----:|:-----------|
|ZIP|[files/archive/test.zip](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/archive/test.zip)|
|TAR|[files/archive/test.tar](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/archive/test.tar)|
|TAR.GZ|[files/archive/test.tar.gz](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/archive/test.tar.gz)|
|BZ2|[files/archive/test.txt.bz2](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/archive/test.txt.bz2)|
|XZ|[files/archive/test.txt.xz](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/archive/test.txt.xz)|

### Email

| Type | Location |
|:----:|:-----------|
|EML|[files/email/test.eml](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/email/test.eml)|
|MSG|[files/email/test.msg](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/email/test.msg)|

### Data

| Type | Location |
|:----:|:-----------|
|CSV|[files/data/test.csv](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/data/test.csv)|
|TSV|[files/data/test.tsv](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/data/test.tsv)|
|GeoJSON|[files/geodata/test.geojson](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/geodata/test.geojson)|
|KML|[files/geodata/test.kml](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/geodata/test.kml)|
|Jupyter Notebook|[files/notebooks/test.ipynb](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/notebooks/test.ipynb)|
|Log|[files/logs/test.log](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/logs/test.log)|

### Other

| Type | Location |
|:----:|:-----------|
|Adobe Illustrator|[files/ai/test.ai](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/ai/test.ai)|
|AutoCAD|files/cad/|
|Font (TTF)|[files/fonts/test.ttf](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/fonts/test.ttf)|
|ISO|[files/disk-images/test.iso](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/disk-images/test.iso)|
|Patch|[files/patches/test.patch](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/patches/test.patch)|
|Diff|[files/patches/test.diff](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/patches/test.diff)|
|Old-style Characters|[files/other/old_style.txt](https://raw.githubusercontent.com/codelibs/fess-testdata/master/files/other/old_style.txt)|

## Docker Environments

The `docker/` directory contains Docker Compose configurations for setting up various data source crawling environments.

| Environment | Description |
|:----:|:-----------|
|basic|Basic Authentication|
|digest|Digest Authentication|
|ldap|LDAP|
|ftp|FTP|
|samba|Samba|
|webdav|WebDAV|
|mysql|MySQL|
|postgresql|PostgreSQL|
|mariadb|MariaDB|
|oracle|Oracle|
|mssql|SQL Server|
|db2|DB2|
|mongodb|MongoDB|
|elasticsearch|Elasticsearch|
|solr|Solr|
|redis|Redis|
|cassandra|Cassandra|
|couchdb|CouchDB|
|minio|MinIO (S3 Compatible)|
|gitlab|GitLab|
|gitea|Gitea|
|redmine|Redmine|
|wordpress|WordPress|
|bugzilla|Bugzilla|
|mantis|MantisBT|
|taiga|Taiga|
|keycloak|Keycloak|
|authentik|Authentik|

## Tools

The `tools/` directory contains utility scripts for data store operations.

| Script | Description |
|:----:|:-----------|
|csvdatastore.sh|CSV Data Store|
|csvlistdatastore.sh|CSV List Data Store|
|csvgeodatastore.sh|CSV Geo Data Store|
|esdatastore.sh|Elasticsearch Data Store|
|eslistdatastore.sh|Elasticsearch List Data Store|
|create_roledata.sh|Role Data Creation|
|encrypt_roles.sh|Role Encryption|
|thumbnail_check.sh|Thumbnail Check|
