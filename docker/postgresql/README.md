PostgreSQL Test Environment
============================

## Overview

This environment provides a PostgreSQL database server for testing Fess database crawling capabilities.

## Run PostgreSQL

```bash
docker compose up -d
```

Wait for PostgreSQL to initialize (first startup takes a few moments).

## Initialize Test Data

If you have SQL files in `data/sql/`, they will be automatically executed on first startup.

You can also manually import data:

```bash
docker compose exec postgresql psql -U testuser -d testdb -f /docker-entrypoint-initdb.d/testdata.sql
```

## Fess Configuration

### Install PostgreSQL JDBC Driver

1. Download PostgreSQL JDBC driver from https://jdbc.postgresql.org/download/

2. Copy the JAR file to Fess's `app/WEB-INF/lib` directory

### Data Store Configuration

Configure a Data Store in Fess with the following settings:

| Name | Value |
|:-----|:------|
| Handler | DatabaseDataStore |
| Parameter | driver=org.postgresql.Driver<br>url=jdbc:postgresql://localhost:5432/testdb<br>username=testuser<br>password=testpass<br>sql=SELECT * FROM documents |
| Script | url="http://localhost/" + id<br>host="localhost"<br>site="localhost"<br>title=title<br>content=content<br>cache=content<br>digest=content<br>anchor=<br>content_length=content.length()<br>last_modified=new java.util.Date() |

### Example Table Schema

```sql
CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO documents (title, content) VALUES
    ('Test Document 1', 'This is test content for document 1'),
    ('Test Document 2', 'This is test content for document 2'),
    ('Test Document 3', 'This is test content for document 3');
```

## Database Connection

- **Host**: localhost
- **Port**: 5432
- **Database**: testdb
- **Username**: testuser
- **Password**: testpass

## Manual Access

```bash
# Connect to PostgreSQL
docker compose exec postgresql psql -U testuser -d testdb

# List tables
\dt

# Query data
SELECT * FROM documents;

# Exit
\q
```

## Stop PostgreSQL

```bash
docker compose down
```

## Notes

- Data is persisted in a Docker volume named `postgres_data`
- SQL files in `data/sql/` directory are executed automatically on first startup
- The database uses UTF-8 encoding by default
