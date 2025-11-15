IBM DB2 Test Environment
=========================

## Overview

This environment provides IBM DB2 Community Edition, IBM's enterprise-grade relational database, for testing Fess enterprise database crawling capabilities.

## ⚠️ Important Notes

- **License**: DB2 Community Edition is free for development and testing
- **Production Use**: Requires DB2 license
- **Memory**: Requires 4GB+ RAM minimum
- **Startup Time**: 3-5 minutes on first run
- **Disk Space**: ~5GB for image and data
- **Privileged Mode**: Container runs in privileged mode

Read IBM's license terms before use: By using this image, you accept the license at http://www-03.ibm.com/software/sla/sladb.nsf

## Run DB2

```bash
docker compose up -d
```

**Wait 3-5 minutes** for DB2 to initialize on first startup.

## Access DB2

- **Port**: 50000
- **Database**: testdb
- **Instance**: db2inst1
- **Password**: db2inst1
- **User**: db2inst1

## Check Startup Progress

```bash
# Watch logs
docker compose logs -f db2

# Wait for this message:
# "Setup has completed"
# "(*) All databases are now active"

# Check if database is ready
docker compose exec db2 su - db2inst1 -c "db2 connect to testdb"
```

## Create Test Data

### Using DB2 CLI

```bash
# Connect to database
docker compose exec db2 su - db2inst1 -c "db2 connect to testdb"

# Create table
docker compose exec db2 su - db2inst1 -c 'db2 "
CREATE TABLE documents (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content CLOB,
    url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)"'

# Insert sample data
docker compose exec db2 su - db2inst1 -c 'db2 "
INSERT INTO documents (title, content, url) VALUES (
    '\''DB2 Test Document 1'\'',
    '\''This is a test document for Fess crawling. IBM DB2 is a family of data management products including database servers.'\'',
    '\''http://localhost/doc1'\''
)"'

docker compose exec db2 su - db2inst1 -c 'db2 "
INSERT INTO documents (title, content, url) VALUES (
    '\''DB2 Test Document 2'\'',
    '\''DB2 provides high performance, scalability, and reliability for mission-critical enterprise applications.'\'',
    '\''http://localhost/doc2'\''
)"'

# Commit
docker compose exec db2 su - db2inst1 -c 'db2 "COMMIT"'

# Query data
docker compose exec db2 su - db2inst1 -c 'db2 "SELECT * FROM documents"'
```

### Using Initialization Script

Create `data/scripts/init.sql`:

```sql
-- DB2 initialization script
CONNECT TO testdb;

CREATE TABLE documents (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content CLOB,
    url VARCHAR(500),
    tags VARCHAR(1000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO documents (title, content, url, tags) VALUES
    ('DB2 Test Document 1',
     'IBM DB2 is a family of data management products. It includes database servers developed by IBM.',
     'http://localhost/doc1',
     'db2,ibm,database'),
    ('DB2 Test Document 2',
     'DB2 provides enterprise-class features including high availability, disaster recovery, and security.',
     'http://localhost/doc2',
     'db2,enterprise,features');

COMMIT;
```

Execute script:

```bash
docker compose exec db2 su - db2inst1 -c "db2 -tvf /var/custom/init.sql"
```

## Fess Configuration

### Install DB2 JDBC Driver

1. Download DB2 JDBC driver (db2jcc4.jar):
   - https://www.ibm.com/support/pages/db2-jdbc-driver-versions-and-downloads

2. Copy to Fess's `app/WEB-INF/lib` directory

### Data Store Configuration

Configure a Data Store in Fess:

| Name | Value |
|:-----|:------|
| Handler | DatabaseDataStore |
| Parameter | driver=com.ibm.db2.jcc.DB2Driver<br>url=jdbc:db2://localhost:50000/testdb<br>username=db2inst1<br>password=db2inst1<br>sql=SELECT * FROM documents |
| Script | url="http://localhost/" + CAST(id AS VARCHAR(10))<br>host="localhost"<br>site="localhost"<br>title=title<br>content=content<br>cache=content<br>digest=content<br>anchor=<br>content_length=LENGTH(content)<br>last_modified=created_at |

## Database Connection

- **Host**: localhost
- **Port**: 50000
- **Database**: testdb
- **Username**: db2inst1
- **Password**: db2inst1
- **Schema**: DB2INST1 (default)

### JDBC Connection String

```
jdbc:db2://localhost:50000/testdb
jdbc:db2://localhost:50000/testdb:user=db2inst1;password=db2inst1;
```

## DB2 Features

- **High Availability**: pureScale, HADR
- **Performance**: BLU Acceleration (column store)
- **Security**: Label-based access control
- **Compression**: Table and index compression
- **Partitioning**: Range, hash, and multidimensional
- **Replication**: SQL Replication, Q Replication
- **XML Support**: Native XML storage
- **JSON Support**: JSON functions and indexing
- **Time Travel**: Temporal tables
- **Analytics**: In-database analytics

## User Management

### Create Users

```bash
# Create OS user (required for DB2)
docker compose exec db2 useradd -m testuser
docker compose exec db2 passwd testuser
# Enter password: testpass123

# Grant database access
docker compose exec db2 su - db2inst1 -c 'db2 "CONNECT TO testdb"'
docker compose exec db2 su - db2inst1 -c 'db2 "GRANT CONNECT ON DATABASE TO USER testuser"'
docker compose exec db2 su - db2inst1 -c 'db2 "GRANT SELECT ON TABLE documents TO USER testuser"'
```

## Administration

### Connect to Database

```bash
# Interactive session
docker compose exec -it db2 bash -c "su - db2inst1"

# Then:
db2 connect to testdb
db2 list tables
db2 "SELECT * FROM documents"
db2 terminate
```

### Database Status

```bash
docker compose exec db2 su - db2inst1 -c "db2 list db directory"
docker compose exec db2 su - db2inst1 -c "db2 list active databases"
docker compose exec db2 su - db2inst1 -c "db2pd -d testdb -applications"
```

### Database Configuration

```bash
# Get database configuration
docker compose exec db2 su - db2inst1 -c "db2 get db cfg for testdb"

# Get database manager configuration
docker compose exec db2 su - db2inst1 -c "db2 get dbm cfg"

# Update configuration
docker compose exec db2 su - db2inst1 -c 'db2 "UPDATE DB CFG FOR testdb USING LOGFILSIZ 1000"'
```

## Backup and Restore

### Backup Database

```bash
# Online backup
docker compose exec db2 su - db2inst1 -c "db2 backup db testdb online to /database/backup"

# Offline backup
docker compose exec db2 su - db2inst1 -c "db2 force applications all"
docker compose exec db2 su - db2inst1 -c "db2 backup db testdb to /database/backup"
```

### Restore Database

```bash
# Restore from backup
docker compose exec db2 su - db2inst1 -c "db2 restore db testdb from /database/backup"
```

### Export Data

```bash
# Export table to file
docker compose exec db2 su - db2inst1 -c 'db2 "EXPORT TO /tmp/documents.ixf OF IXF SELECT * FROM documents"'

# Copy from container
docker compose cp db2:/tmp/documents.ixf ./
```

### Import Data

```bash
# Copy to container
docker compose cp documents.ixf db2:/tmp/

# Import from file
docker compose exec db2 su - db2inst1 -c 'db2 "IMPORT FROM /tmp/documents.ixf OF IXF INSERT INTO documents"'
```

## Performance Tuning

### Create Indexes

```bash
docker compose exec db2 su - db2inst1 -c 'db2 "CREATE INDEX idx_title ON documents(title)"'
docker compose exec db2 su - db2inst1 -c 'db2 "CREATE INDEX idx_created ON documents(created_at)"'
```

### Update Statistics

```bash
docker compose exec db2 su - db2inst1 -c 'db2 "RUNSTATS ON TABLE DB2INST1.DOCUMENTS"'
```

### Check Execution Plan

```bash
docker compose exec db2 su - db2inst1 -c 'db2 "EXPLAIN PLAN FOR SELECT * FROM documents WHERE title LIKE '\''%DB2%'\''"'
```

### Enable Query Optimization

```bash
docker compose exec db2 su - db2inst1 -c 'db2 "REORG TABLE documents"'
```

## Text Search

DB2 includes text search capabilities:

```sql
-- Create text search index (requires Text Search component)
-- CREATE INDEX idx_text ON documents(content) USING TEXT SEARCH INDEX;

-- Full-text search
-- SELECT * FROM documents WHERE CONTAINS(content, 'database') = 1;
```

## Monitoring

```bash
# View logs
docker compose logs -f db2

# Check database size
docker compose exec db2 su - db2inst1 -c 'db2 "
SELECT
    SUBSTR(TABSCHEMA,1,20) as SCHEMA,
    SUBSTR(TABNAME,1,30) as TABLE_NAME,
    DATA_OBJECT_P_SIZE/1024 as DATA_SIZE_MB,
    INDEX_OBJECT_P_SIZE/1024 as INDEX_SIZE_MB
FROM TABLE(SYSPROC.ADMIN_GET_TAB_INFO('\'''\''','\''DOCUMENTS'\'')) AS T"'

# List connections
docker compose exec db2 su - db2inst1 -c "db2 list applications"

# Database health
docker compose exec db2 su - db2inst1 -c "db2 get snapshot for database on testdb"
```

## Stop DB2

```bash
docker compose down
```

**Note**: Clean shutdown takes 30-60 seconds.

## Troubleshooting

### Long startup time

First startup takes 3-5 minutes:

```bash
docker compose logs -f db2
# Wait for "Setup has completed"
```

### SQL1013N: The database alias name or database name "testdb" could not be found

Database still initializing. Wait longer.

### SQL1024N: A database connection does not exist

Reconnect:

```bash
docker compose exec db2 su - db2inst1 -c "db2 connect to testdb"
```

### Out of memory

Increase Docker memory to 6GB+:
- Docker Desktop → Settings → Resources → Memory

### Permission denied errors

Container needs privileged mode (already configured in compose.yaml).

## Performance Notes

DB2 Community Edition limitations:
- **Free for development**
- **Up to 16GB RAM**
- **Up to 4 cores**
- **Smaller feature set** than Enterprise

For production, use DB2 Standard or Advanced Edition.

## Security

1. **Change passwords**:
   ```bash
   docker compose exec db2 passwd db2inst1
   # Enter new password
   ```

2. **Restrict network access** to port 50000

3. **Use SSL/TLS** for encrypted connections

4. **Enable auditing**:
   ```bash
   docker compose exec db2 su - db2inst1 -c 'db2 "UPDATE DB CFG FOR testdb USING AUDIT_BUF_SZ 1000"'
   ```

5. **Regular backups** using DB2 backup

6. **Keep updated**: IBM security patches

## Comparison: DB2 vs Other Databases

| Feature | DB2 | Oracle | SQL Server | PostgreSQL |
|---------|-----|--------|------------|------------|
| Vendor | IBM | Oracle | Microsoft | Open source |
| License | Commercial | Commercial | Commercial | Open source |
| Memory | 16GB (CE) | 2GB (XE) | 1.4GB (Expr) | Unlimited |
| Platform | AIX, Linux, Windows | Linux, Windows | Windows, Linux | All platforms |
| Use Case | Enterprise, Mainframe | Enterprise | Microsoft stack | General purpose |

## Use Cases for Fess

1. **Enterprise Integration**: Search mainframe data
2. **Legacy Systems**: Index DB2 databases
3. **Data Warehouse**: Search analytical databases
4. **Compliance**: Search archived data
5. **Multi-platform**: Bridge DB2 and other systems

## Notes

- **Port 50000**: Database listener
- **Memory**: 4GB+ recommended
- **Startup**: 3-5 minutes first time
- **Image Size**: ~5GB
- **Privileged**: Requires privileged mode
- **Edition**: Community (free, development use)
- **Platform**: Primarily Linux/UNIX

## Resources

- [DB2 Community Edition](https://www.ibm.com/products/db2-database)
- [DB2 Documentation](https://www.ibm.com/docs/en/db2/)
- [DB2 JDBC Driver](https://www.ibm.com/support/pages/db2-jdbc-driver-versions-and-downloads)
- [DB2 Knowledge Center](https://www.ibm.com/support/knowledgecenter/SSEPGG)
- [Docker Image](https://hub.docker.com/r/ibmcom/db2)
