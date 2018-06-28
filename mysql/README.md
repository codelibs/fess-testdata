MySQLテスト用環境
================

## 概要

fess用のmsqlテスト環境です。

## 起動方法(MySQL & Adminer)

```
$ docker-compose up
```

### データ入力

1. `http://localhost:8083` を開きます。

1. ユーザー名:「hoge」、パスワード:「fuga」、データベース:「testdb」でログインします。

1. インポートを押下し、`testdb.sql`をアップロードします。

## FESSの操作

1. Fessをインストールします。

1. `https://dev.mysql.com/downloads/` に接続します。

1. 「MySQL connectors」を押下し、「Connector/J」をクリックします。

1. 「Select Operating System:」を「Platform Independent」に設定し、ZIPフォルダをダウンロードを押下します。

1. サイトを下にスクロールし「No thanks,just start my download」を押し、ダウンロードを開始します。

1. インストール後フォルダを解凍し、中のjarファイルをfessのapp/WEB-INF/libにコピーします。

1. Fessを起動します。

1. 以下の設定のデータストアクロールを作成します。

|種類|値|
|:------:|:--|
|ハンドラ名|DatabaseDataStore|
|パラメータ|driver=com.mysql.jdbc.Driver<br>url=jdbc:mysql://localhost:3306/testdb?useUnicode=true&characterEncoding=UTF-8<br>username=hoge<br>password=fuga<br>sql=select * from doc|
|スクリプト|url="http://localhost/" + id<br>host="localhost"<br>site="localhost"<br>title=title<br>content=content<br>cache=content<br>digest=content<br>anchor=<br>content_length=content.length()<br>last_modified=new java.util.Date()<br>location=latitude + "," + longitude<br>latitude=latitude<br>longitude=longitude|

