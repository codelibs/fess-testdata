MongoDB Test Environment
========================

## Overview

This environment provides a MongoDB database server for testing Fess NoSQL database crawling capabilities.

## Run MongoDB

```bash
docker compose up -d
```

## Initialize Test Data

Load sample data using the provided initialization script:

```bash
docker compose exec mongodb mongosh -u admin -p admin123 --authenticationDatabase admin testdb < data/init/init.js
```

Or interactively:

```bash
docker compose exec mongodb mongosh -u admin -p admin123 --authenticationDatabase admin
use testdb
db.documents.insertMany([
  {
    title: "Test Document 1",
    content: "Sample content for testing Fess crawling",
    url: "http://localhost/doc1",
    tags: ["test", "sample"]
  },
  {
    title: "Test Document 2",
    content: "Another document with different content",
    url: "http://localhost/doc2",
    tags: ["test", "mongodb"]
  }
]);
```

## Fess Configuration

### Install MongoDB Java Driver

1. Download MongoDB Java Driver from https://mongodb.github.io/mongo-java-driver/

2. Copy the JAR file to Fess's `app/WEB-INF/lib` directory

### Data Store Configuration

Configure a Data Store in Fess with the following settings:

| Name | Value |
|:-----|:------|
| Handler | DatabaseDataStore |
| Parameter | driver=org.codelibs.fess.ds.impl.MongoDataStoreImpl<br>url=mongodb://admin:admin123@localhost:27017/testdb?authSource=admin<br>collection=documents |
| Script | url=url<br>host="localhost"<br>site="localhost"<br>title=title<br>content=content<br>cache=content<br>digest=content<br>anchor=<br>content_length=content.length()<br>last_modified=created_at |

**Note**: MongoDB integration may require custom implementation or plugins depending on your Fess version.

## Database Connection

- **Host**: localhost
- **Port**: 27017
- **Database**: testdb
- **Admin Username**: admin
- **Admin Password**: admin123

## Manual Access

```bash
# Connect to MongoDB using mongosh
docker compose exec mongodb mongosh -u admin -p admin123 --authenticationDatabase admin

# Switch to test database
use testdb

# List collections
show collections

# Query documents
db.documents.find().pretty()

# Exit
exit
```

## Example Usage

### Insert Test Documents

```javascript
use testdb

db.documents.insertMany([
  {
    title: "MongoDB Test 1",
    content: "This is a test document for Fess MongoDB crawling",
    url: "http://localhost/mongo1",
    tags: ["database", "nosql"],
    created_at: new Date()
  },
  {
    title: "MongoDB Test 2",
    content: "MongoDB is a document-oriented NoSQL database",
    url: "http://localhost/mongo2",
    tags: ["mongodb", "document"],
    created_at: new Date()
  },
  {
    title: "テストドキュメント3",
    content: "MongoDBは日本語のUTF-8文字列も扱えます",
    url: "http://localhost/mongo3",
    tags: ["日本語", "テスト"],
    created_at: new Date()
  }
]);

// Verify insertion
db.documents.countDocuments()
```

### Create Indexes

```javascript
db.documents.createIndex({ title: 1 })
db.documents.createIndex({ tags: 1 })
db.documents.createIndex({ created_at: -1 })
```

## Stop MongoDB

```bash
docker compose down
```

## Notes

- Data is persisted in a Docker volume named `mongo_data`
- MongoDB uses authentication by default
- The database uses UTF-8 encoding for all text data
- JavaScript files in `data/init/` directory can be executed on startup
