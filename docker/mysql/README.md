MySQL Test Environment
================

## Run MySQL

```bash
docker compose up -d
docker compose exec mysql bash -c "mysql -u hoge -pfuga testdb < /sql/testdb.sql"
```

## Fess

### Install MySQL jar file

1. Access `https://dev.mysql.com/downloads/`

1. Download mysql\*.jar file from MySQL connectors

1. Copy it to app/WEB-INF/lib

### Data Store setting

|Name|Value|
|:------:|:--|
|Handler|DatabaseDataStore|
|Parameter|driver=com.mysql.jdbc.Driver<br>url=jdbc:mysql://localhost:3306/testdb?useUnicode=true&characterEncoding=UTF-8&enabledTLSProtocols=TLSv1.2<br>username=hoge<br>password=fuga<br>sql=select * from doc|
|Script|url="http://localhost/" + id<br>host="localhost"<br>site="localhost"<br>title=title<br>content=content<br>cache=content<br>digest=content<br>anchor=<br>content_length=content.length()<br>last_modified=new java.util.Date()<br>location=latitude + "," + longitude<br>latitude=latitude<br>longitude=longitude|

## Stop MySQL

```bash
docker compose down
```
