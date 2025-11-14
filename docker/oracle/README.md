Oracle Database XE Test Environment
====================================

## Overview

This environment provides Oracle Database 21c Express Edition (XE), the world's most popular commercial database, for testing Fess enterprise database crawling capabilities.

## ⚠️ Important Notes

- **License**: Oracle XE is free for development and testing
- **Production Use**: Requires Oracle Database license
- **Memory**: Requires 2GB+ RAM minimum
- **Startup Time**: 2-3 minutes on first run
- **Disk Space**: ~4GB for image and data

Read Oracle's license terms before use.

## Run Oracle Database

```bash
docker compose up -d
```

**Wait 2-3 minutes** for Oracle to initialize on first startup.

## Access Oracle Database

- **Port**: 1521 (database)
- **EM Express**: http://localhost:5500/em (web console)
- **SID**: XE
- **Service Name**: XEPDB1
- **Passwords**:
  - SYS/SYSTEM: Oracle123
  - Test User: testuser / testpass
  - Test Database: testdb

## Check Startup Progress

```bash
# Watch logs
docker compose logs -f oracle

# Wait for this message:
# "DATABASE IS READY TO USE!"

# Check if database is ready
docker compose exec oracle sqlplus system/Oracle123@localhost/XEPDB1 <<< "SELECT 'Ready' FROM dual;"
```

## Create Test Data

### Using SQL*Plus

```bash
# Connect as testuser
docker compose exec oracle sqlplus testuser/testpass@localhost/XEPDB1

# Create table
CREATE TABLE documents (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR2(255) NOT NULL,
    content CLOB,
    url VARCHAR2(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

# Insert sample data
INSERT INTO documents (title, content, url) VALUES (
    'Oracle Test Document 1',
    'This is a test document for Fess crawling. Oracle Database is the world''s most popular enterprise database.',
    'http://localhost/doc1'
);

INSERT INTO documents (title, content, url) VALUES (
    'Oracle Test Document 2',
    'Oracle Database provides high performance, scalability, and reliability for mission-critical applications.',
    'http://localhost/doc2'
);

INSERT INTO documents (title, content, url) VALUES (
    'テストドキュメント3',
    'Oracle DatabaseはマルチバイトUTF-8をサポートしており、日本語データを格納できます。',
    'http://localhost/doc3'
);

COMMIT;

# Query data
SELECT * FROM documents;

# Exit
EXIT;
```

### Using Initialization Script

Create `data/scripts/init.sql`:

```sql
-- This file is automatically executed on container startup

-- Connect to PDB
ALTER SESSION SET CONTAINER = XEPDB1;

-- Create table as testuser
CREATE TABLE testuser.documents (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR2(255) NOT NULL,
    content CLOB,
    url VARCHAR2(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO testuser.documents (title, content, url) VALUES (
    'Oracle Database Overview',
    'Oracle Database is a multi-model database management system produced by Oracle Corporation.',
    'http://localhost/doc1'
);

COMMIT;
```

Then restart: `docker compose restart oracle`

## Fess Configuration

### Install Oracle JDBC Driver

1. Download Oracle JDBC driver (ojdbc8.jar or later):
   - https://www.oracle.com/database/technologies/appdev/jdbc-downloads.html

2. Copy to Fess's `app/WEB-INF/lib` directory

### Data Store Configuration

Configure a Data Store in Fess:

| Name | Value |
|:-----|:------|
| Handler | DatabaseDataStore |
| Parameter | driver=oracle.jdbc.OracleDriver<br>url=jdbc:oracle:thin:@localhost:1521/XEPDB1<br>username=testuser<br>password=testpass<br>sql=SELECT * FROM documents |
| Script | url="http://localhost/" + id<br>host="localhost"<br>site="localhost"<br>title=title<br>content=content<br>cache=content<br>digest=content<br>anchor=<br>content_length=LENGTH(content)<br>last_modified=created_at |

## Database Connection

- **Host**: localhost
- **Port**: 1521
- **Service Name**: XEPDB1 (Pluggable Database)
- **SID**: XE (Container Database)
- **System User**: system / Oracle123
- **App User**: testuser / testpass

### Connection Strings

```
# Thin driver format
jdbc:oracle:thin:@localhost:1521/XEPDB1

# TNS format
jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=XEPDB1)))
```

## Oracle Features

- **Multi-Model**: Relational, JSON, XML, Spatial, Graph
- **High Availability**: RAC, Data Guard
- **Security**: Advanced security features
- **Performance**: Query optimization, in-memory processing
- **Scalability**: Partitioning, sharding
- **PL/SQL**: Powerful procedural language
- **Developer Tools**: SQL Developer, EM Express
- **JSON Support**: Native JSON data type
- **Full-Text Search**: Oracle Text

## User Management

### Create Users

```sql
# Connect as SYSTEM
docker compose exec oracle sqlplus system/Oracle123@localhost/XEPDB1

-- Create user
CREATE USER newuser IDENTIFIED BY newpass123
  DEFAULT TABLESPACE users
  TEMPORARY TABLESPACE temp
  QUOTA UNLIMITED ON users;

-- Grant privileges
GRANT CONNECT, RESOURCE TO newuser;
GRANT CREATE SESSION TO newuser;
GRANT CREATE TABLE TO newuser;
GRANT CREATE VIEW TO newuser;

EXIT;
```

### Grant Permissions

```sql
-- Grant table access
GRANT SELECT ON testuser.documents TO newuser;
GRANT INSERT, UPDATE, DELETE ON testuser.documents TO newuser;

-- Grant all privileges
GRANT ALL PRIVILEGES TO newuser;
```

## Administration

### Connect as SYS (SYSDBA)

```bash
docker compose exec oracle sqlplus sys/Oracle123@localhost/XEPDB1 as sysdba
```

### Check Database Status

```sql
SELECT instance_name, status, database_status FROM v$instance;
SELECT name, open_mode FROM v$database;
SELECT name, open_mode FROM v$pdbs;
```

### Switch Between CDB and PDB

```sql
-- Show current container
SHOW CON_NAME;

-- Switch to root container
ALTER SESSION SET CONTAINER = CDB$ROOT;

-- Switch to pluggable database
ALTER SESSION SET CONTAINER = XEPDB1;
```

### Database Size

```sql
SELECT SUM(bytes)/1024/1024/1024 AS size_gb
FROM dba_data_files;
```

## EM Express Web Console

1. Open http://localhost:5500/em
2. Login:
   - Container: XEPDB1
   - Username: system
   - Password: Oracle123
3. Navigate through:
   - Performance Hub
   - Storage
   - Security
   - Configuration

## Backup and Export

### Export Data (Data Pump)

```bash
# Export schema
docker compose exec oracle expdp testuser/testpass@XEPDB1 \
  schemas=testuser \
  directory=DATA_PUMP_DIR \
  dumpfile=testuser.dmp \
  logfile=export.log
```

### Import Data

```bash
docker compose exec oracle impdp testuser/testpass@XEPDB1 \
  schemas=testuser \
  directory=DATA_PUMP_DIR \
  dumpfile=testuser.dmp \
  logfile=import.log
```

### Traditional Export

```bash
# Export table
docker compose exec oracle exp testuser/testpass@XEPDB1 \
  file=documents.dmp \
  tables=documents
```

## Performance Tuning

### Check Execution Plan

```sql
EXPLAIN PLAN FOR
SELECT * FROM documents WHERE title LIKE '%Oracle%';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
```

### Create Indexes

```sql
-- B-tree index
CREATE INDEX idx_title ON documents(title);

-- Function-based index
CREATE INDEX idx_upper_title ON documents(UPPER(title));

-- Full-text index (Oracle Text)
CREATE INDEX idx_content ON documents(content)
INDEXTYPE IS CTXSYS.CONTEXT;
```

### Statistics

```sql
-- Gather table statistics
EXEC DBMS_STATS.GATHER_TABLE_STATS('TESTUSER', 'DOCUMENTS');

-- Check statistics
SELECT table_name, num_rows, last_analyzed
FROM user_tables
WHERE table_name = 'DOCUMENTS';
```

## Oracle Text (Full-Text Search)

```sql
-- Create text index
CREATE INDEX idx_ft_content ON documents(content)
INDEXTYPE IS CTXSYS.CONTEXT;

-- Full-text search
SELECT * FROM documents
WHERE CONTAINS(content, 'Oracle AND database') > 0;

-- Fuzzy search
SELECT * FROM documents
WHERE CONTAINS(content, 'fuzzy(Oracl, 80)') > 0;

-- Sync index
EXEC CTX_DDL.SYNC_INDEX('idx_ft_content');
```

## Monitoring

```bash
# View logs
docker compose logs -f oracle

# Check processes
docker compose exec oracle ps -ef | grep oracle

# Database size
docker compose exec oracle sqlplus system/Oracle123@XEPDB1 <<< "
  SELECT tablespace_name,
         ROUND(SUM(bytes)/1024/1024, 2) AS size_mb
  FROM dba_data_files
  GROUP BY tablespace_name;"

# Check sessions
docker compose exec oracle sqlplus system/Oracle123@XEPDB1 <<< "
  SELECT username, COUNT(*)
  FROM v\$session
  WHERE username IS NOT NULL
  GROUP BY username;"
```

## Stop Oracle Database

```bash
docker compose down
```

**Note**: Clean shutdown takes 30-60 seconds.

## Troubleshooting

### Long startup time

First startup takes 2-3 minutes for database initialization:

```bash
docker compose logs -f oracle
# Wait for "DATABASE IS READY TO USE!"
```

### ORA-12514: TNS:listener does not currently know of service

Wait longer, or check service name:

```sql
SELECT name, pdb FROM v$services;
```

### Out of memory

Increase Docker memory to 4GB+:
- Docker Desktop → Settings → Resources → Memory

### Connection refused

Check if container is running:
```bash
docker compose ps
docker compose logs oracle
```

## Performance Notes

Oracle XE limitations:
- **Max RAM**: 2GB
- **Max Storage**: 12GB user data
- **Max CPU**: 2 threads
- **Pluggable DBs**: 1 (XEPDB1)

For production, use Enterprise or Standard Edition.

## Security

1. **Change passwords** immediately:
   ```sql
   ALTER USER system IDENTIFIED BY NewPassword123;
   ALTER USER testuser IDENTIFIED BY NewPassword123;
   ```

2. **Restrict network access** to database port

3. **Use encrypted connections** (TLS/SSL)

4. **Regular backups** with RMAN or Data Pump

5. **Keep updated**: Oracle security patches

6. **Audit**: Enable database auditing
   ```sql
   AUDIT SELECT ON testuser.documents;
   ```

## Comparison: Oracle vs Other Databases

| Feature | Oracle XE | PostgreSQL | SQL Server |
|---------|-----------|------------|------------|
| License | Free (dev/test) | Open source | Express: Free |
| Memory | 2GB max | Configurable | 1.4GB max |
| Storage | 12GB max | Unlimited | 10GB max |
| Features | Subset | Full | Subset |
| Support | Community | Community | Community |

## Use Cases for Fess

1. **Enterprise Data**: Index corporate database content
2. **Legacy Systems**: Search old Oracle databases
3. **PL/SQL Search**: Index stored procedures (via metadata)
4. **LOB Search**: Search large text/binary objects
5. **Multi-language**: Japanese/Chinese content support

## Notes

- **Port 1521**: Database listener
- **Port 5500**: EM Express web console
- **Memory**: 2GB+ recommended
- **Startup**: 2-3 minutes first time
- **Image Size**: ~4GB
- **Database**: Pluggable architecture (CDB + PDB)
- **Edition**: Express (free, limited resources)

## Resources

- [Oracle Database XE](https://www.oracle.com/database/technologies/appdev/xe.html)
- [Oracle Documentation](https://docs.oracle.com/en/database/)
- [Oracle JDBC Driver](https://www.oracle.com/database/technologies/appdev/jdbc-downloads.html)
- [SQL*Plus User Guide](https://docs.oracle.com/en/database/oracle/oracle-database/21/sqpug/)
- [Docker Image](https://github.com/gvenzl/oci-oracle-xe)
