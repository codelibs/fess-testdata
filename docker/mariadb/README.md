MariaDB Test Environment
========================

## Overview

This environment provides a MariaDB database server (MySQL-compatible) for testing Fess database crawling capabilities.

## Run MariaDB

```bash
docker compose up -d
```

Wait for MariaDB to initialize (first startup takes a few moments).

## Initialize Test Data

SQL files in `data/sql/` are automatically executed on first startup.

You can also manually import data:

```bash
docker compose exec mariadb mariadb -u testuser -ptestpass testdb < data/sql/additional_data.sql
```

## Fess Configuration

### Install MariaDB/MySQL JDBC Driver

1. Download MySQL Connector/J from https://dev.mysql.com/downloads/connector/j/

2. Copy the JAR file to Fess's `app/WEB-INF/lib` directory

### Data Store Configuration

Configure a Data Store in Fess with the following settings:

| Name | Value |
|:-----|:------|
| Handler | DatabaseDataStore |
| Parameter | driver=org.mariadb.jdbc.Driver<br>url=jdbc:mariadb://localhost:3307/testdb?characterEncoding=UTF-8<br>username=testuser<br>password=testpass<br>sql=SELECT * FROM documents |
| Script | url="http://localhost/" + id<br>host="localhost"<br>site="localhost"<br>title=title<br>content=content<br>cache=content<br>digest=content<br>anchor=<br>content_length=content.length()<br>last_modified=created_at |

**Note**: MariaDB is fully compatible with MySQL drivers, so you can use either `com.mysql.cj.jdbc.Driver` or `org.mariadb.jdbc.Driver`.

## Database Connection

- **Host**: localhost
- **Port**: 3307 (using non-standard port to avoid conflict with MySQL)
- **Database**: testdb
- **Username**: testuser
- **Password**: testpass
- **Root Password**: root

## Manual Access

```bash
# Connect to MariaDB as testuser
docker compose exec mariadb mariadb -u testuser -ptestpass testdb

# Connect as root
docker compose exec mariadb mariadb -u root -proot

# Show databases
SHOW DATABASES;

# Use testdb
USE testdb;

# Show tables
SHOW TABLES;

# Query data
SELECT * FROM documents;

# Exit
EXIT;
```

## Example Queries

```sql
-- Show table structure
DESCRIBE documents;

-- Count records
SELECT COUNT(*) FROM documents;

-- Search by title
SELECT * FROM documents WHERE title LIKE '%Test%';

-- Full-text search (if enabled)
SELECT * FROM documents WHERE MATCH(title, content) AGAINST('Redis' IN NATURAL LANGUAGE MODE);
```

## Stop MariaDB

```bash
docker compose down
```

## Differences from MySQL

While MariaDB is MySQL-compatible, it offers:

- Better performance in many scenarios
- More storage engines (Aria, ColumnStore)
- Enhanced JSON support
- Improved replication features
- Open source with no commercial restrictions

## Performance Tuning

The container is configured with:
- UTF-8 MB4 character set (full Unicode support)
- Optimized for development/testing
- Data persisted in Docker volume

For production, consider tuning these parameters in `compose.yaml`:

```yaml
command: >
  --character-set-server=utf8mb4
  --collation-server=utf8mb4_unicode_ci
  --max_connections=200
  --innodb_buffer_pool_size=512M
```

## Notes

- Port 3307 is used to avoid conflicts with MySQL on port 3306
- Data is persisted in a Docker volume named `mariadb_data`
- Character set is UTF-8 MB4 (supports emojis and full Unicode)
- SQL files in `data/sql/` are executed in alphabetical order on first startup
- Compatible with MySQL clients and tools
