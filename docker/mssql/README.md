Microsoft SQL Server Test Environment
======================================

## Overview

This environment provides Microsoft SQL Server 2022 Express for testing Fess database crawling capabilities with enterprise Windows-based systems.

## Run SQL Server

```bash
docker compose up -d
```

Wait for SQL Server to initialize (first startup takes 30-60 seconds).

## Initialize Test Data

After the container starts, initialize the database and load sample data:

```bash
# Wait for SQL Server to be ready
sleep 30

# Create database and load data
docker compose exec mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'MyStrongPass123!' -Q "CREATE DATABASE testdb;"

docker compose exec mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'MyStrongPass123!' -d testdb -i /docker-entrypoint-initdb.d/init.sql
```

Or use the provided initialization script:

```bash
chmod +x data/sql/setup.sh
./data/sql/setup.sh
```

## Fess Configuration

### Install SQL Server JDBC Driver

1. Download Microsoft JDBC Driver for SQL Server from:
   https://docs.microsoft.com/en-us/sql/connect/jdbc/download-microsoft-jdbc-driver-for-sql-server

2. Copy `mssql-jdbc-*.jar` to Fess's `app/WEB-INF/lib` directory

### Data Store Configuration

Configure a Data Store in Fess with the following settings:

| Name | Value |
|:-----|:------|
| Handler | DatabaseDataStore |
| Parameter | driver=com.microsoft.sqlserver.jdbc.SQLServerDriver<br>url=jdbc:sqlserver://localhost:1433;databaseName=testdb;encrypt=false;trustServerCertificate=true<br>username=sa<br>password=MyStrongPass123!<br>sql=SELECT * FROM documents |
| Script | url="http://localhost/" + id<br>host="localhost"<br>site="localhost"<br>title=title<br>content=content<br>cache=content<br>digest=content<br>anchor=<br>content_length=content.length()<br>last_modified=created_at |

## Database Connection

- **Host**: localhost
- **Port**: 1433
- **Database**: testdb
- **Username**: sa
- **Password**: MyStrongPass123!
- **Edition**: Express (free)

## Manual Access

### Using sqlcmd (in container)

```bash
# Connect to SQL Server
docker compose exec mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'MyStrongPass123!'

# SQL commands
1> SELECT @@VERSION;
2> GO

1> USE testdb;
2> GO

1> SELECT * FROM documents;
2> GO

1> EXIT
```

### Using Azure Data Studio or SQL Server Management Studio

- Server: localhost,1433
- Authentication: SQL Server Authentication
- Login: sa
- Password: MyStrongPass123!

## Example Queries

```sql
-- Show all databases
SELECT name, database_id, create_date
FROM sys.databases;

-- Use testdb
USE testdb;
GO

-- Show all tables
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

-- Query documents
SELECT * FROM documents;

-- Full-text search (if configured)
SELECT id, title, content
FROM documents
WHERE CONTAINS(content, 'SQL Server');

-- Count records
SELECT COUNT(*) as TotalDocuments FROM documents;
```

## Stop SQL Server

```bash
docker compose down
```

## SQL Server Features

This environment includes:

- **SQL Server 2022 Express Edition** (free, production-ready)
- **T-SQL support** (Transact-SQL extensions)
- **Full Unicode support** with Japanese collation
- **Built-in JSON support** (FOR JSON, OPENJSON)
- **Window functions** and advanced analytics
- **XML data type** and XQuery support

## Common Administrative Tasks

### Create New User

```sql
-- Create login
CREATE LOGIN testuser WITH PASSWORD = 'TestPass123!';
GO

-- Create user in testdb
USE testdb;
GO

CREATE USER testuser FOR LOGIN testuser;
GO

-- Grant permissions
ALTER ROLE db_datareader ADD MEMBER testuser;
ALTER ROLE db_datawriter ADD MEMBER testuser;
GO
```

### Backup Database

```bash
docker compose exec mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'MyStrongPass123!' -Q "BACKUP DATABASE testdb TO DISK = '/var/opt/mssql/data/testdb.bak' WITH FORMAT, INIT, NAME = 'testdb-full';"
```

### Check Database Size

```sql
USE testdb;
GO

EXEC sp_spaceused;
GO
```

## Performance Tuning

SQL Server Express limitations:
- Maximum database size: 10 GB
- Maximum memory: 1410 MB
- Maximum CPU cores: Lesser of 1 socket or 4 cores

For better performance, configure memory in compose.yaml:

```yaml
environment:
  MSSQL_MEMORY_LIMIT_MB: 1024
```

## Notes

- **EULA Acceptance**: By using this image, you accept Microsoft's End-User License Agreement
- **Password Policy**: SA password must meet complexity requirements (uppercase, lowercase, digits, symbols)
- **Port 1433**: Standard SQL Server port
- **Collation**: Japanese_CI_AS for Japanese language support
- **Encryption**: Disabled for testing (enable in production)
- **Data Persistence**: All data stored in Docker volume `mssql_data`

## Troubleshooting

### Container exits immediately

Check that password meets requirements:
- At least 8 characters
- Contains uppercase, lowercase, digits, and symbols

### Cannot connect

Wait for SQL Server to fully start (30-60 seconds on first run):

```bash
docker compose logs -f mssql
# Wait for "SQL Server is now ready for client connections"
```

### Memory issues

SQL Server requires at least 2GB RAM. Increase Docker memory allocation if needed.
