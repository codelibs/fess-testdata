Apache Cassandra Test Environment
==================================

## Overview

This environment provides Apache Cassandra, a highly scalable distributed NoSQL database, for testing Fess large-scale data crawling capabilities.

## Run Cassandra

```bash
docker compose up -d
```

Wait for Cassandra to initialize (takes 60-90 seconds on first run).

**Note**: Cassandra requires at least 2GB RAM. Ensure Docker has sufficient memory allocated.

## Check Status

```bash
# Wait for Cassandra to be ready
docker compose logs -f cassandra
# Wait for "Created default superuser role"

# Check node status
docker compose exec cassandra nodetool status

# Check if CQL is ready
docker compose exec cassandra cqlsh -e "SELECT cluster_name FROM system.local;"
```

## Initialize Test Data

### Using cqlsh

```bash
# Connect to Cassandra
docker compose exec cassandra cqlsh

# Create keyspace
CREATE KEYSPACE IF NOT EXISTS testdb
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

# Use keyspace
USE testdb;

# Create table
CREATE TABLE IF NOT EXISTS documents (
    id UUID PRIMARY KEY,
    title TEXT,
    content TEXT,
    url TEXT,
    created_at TIMESTAMP
);

# Insert data
INSERT INTO documents (id, title, content, url, created_at)
VALUES (uuid(), 'Cassandra Test 1', 'This is a test document', 'http://localhost/doc1', toTimestamp(now()));

# Query data
SELECT * FROM documents;

# Exit
EXIT;
```

Or use the provided initialization script:

```bash
chmod +x data/load_data.sh
./data/load_data.sh
```

## Fess Configuration

### Data Store Configuration

Cassandra requires custom integration:

| Name | Value |
|:-----|:------|
| Handler | Custom Cassandra DataStore |
| Parameter | contactPoints=localhost<br>port=9042<br>keyspace=testdb<br>table=documents<br>username=cassandra<br>password=cassandra |

**Note**: Integration requires:
1. Cassandra Java Driver
2. Custom DataStore implementation
3. CQL query configuration

### Example Driver Code

```java
// Connect to Cassandra
Cluster cluster = Cluster.builder()
    .addContactPoint("localhost")
    .withPort(9042)
    .build();

Session session = cluster.connect("testdb");

// Query data
ResultSet results = session.execute("SELECT * FROM documents");

for (Row row : results) {
    String title = row.getString("title");
    String content = row.getString("content");
    // Process and index in Fess
}
```

## Database Connection

- **Host**: localhost
- **Port**: 9042 (CQL native protocol)
- **JMX Port**: 7199
- **Cluster**: TestCluster
- **Default Keyspace**: system
- **Default User**: cassandra
- **Default Password**: cassandra

## Manual Operations

### Using cqlsh

```bash
# Connect to Cassandra
docker compose exec cassandra cqlsh

# List keyspaces
DESCRIBE KEYSPACES;

# Create keyspace
CREATE KEYSPACE myapp
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

# Use keyspace
USE myapp;

# Create table
CREATE TABLE users (
    id UUID PRIMARY KEY,
    name TEXT,
    email TEXT,
    created_at TIMESTAMP
);

# Insert data
INSERT INTO users (id, name, email, created_at)
VALUES (uuid(), 'John Doe', 'john@example.com', toTimestamp(now()));

# Query data
SELECT * FROM users;

# Update data
UPDATE users SET email = 'newemail@example.com' WHERE id = <uuid>;

# Delete data
DELETE FROM users WHERE id = <uuid>;

# Drop table
DROP TABLE users;

# Drop keyspace
DROP KEYSPACE myapp;
```

### CQL Query Examples

```sql
-- Range queries
SELECT * FROM documents WHERE created_at > '2025-01-01';

-- Limit results
SELECT * FROM documents LIMIT 10;

-- Count rows (expensive operation!)
SELECT COUNT(*) FROM documents;

-- Order by (requires CLUSTERING ORDER in table definition)
SELECT * FROM documents ORDER BY created_at DESC;

-- Filter with ALLOW FILTERING (expensive!)
SELECT * FROM documents WHERE title = 'Test' ALLOW FILTERING;

-- Batch operations
BEGIN BATCH
  INSERT INTO documents (id, title, content) VALUES (uuid(), 'Doc1', 'Content1');
  INSERT INTO documents (id, title, content) VALUES (uuid(), 'Doc2', 'Content2');
APPLY BATCH;
```

### Using nodetool

```bash
# Check cluster status
docker compose exec cassandra nodetool status

# Get info about current node
docker compose exec cassandra nodetool info

# View keyspaces
docker compose exec cassandra nodetool describecluster

# Check data size
docker compose exec cassandra nodetool tablestats testdb.documents

# Flush memtables to disk
docker compose exec cassandra nodetool flush

# Compact SSTables
docker compose exec cassandra nodetool compact testdb documents

# Repair data
docker compose exec cassandra nodetool repair testdb
```

## Apache Cassandra Features

- **Distributed**: Scales horizontally across nodes
- **No Single Point of Failure**: All nodes are equal (peer-to-peer)
- **High Availability**: Replication and automatic failover
- **Linear Scalability**: Add nodes without downtime
- **Tunable Consistency**: Choose between consistency and performance
- **CQL**: SQL-like query language
- **Wide Column Store**: Flexible schema design
- **Time Series**: Excellent for time-series data

## Data Modeling

Cassandra requires different thinking from RDBMS:

### Best Practices

1. **Query-First Design**: Design tables for specific queries
2. **Denormalization**: Duplicate data across tables
3. **Partition Key**: Choose wisely for even distribution
4. **Clustering Columns**: Define sort order within partition
5. **Avoid JOINs**: Cassandra doesn't support JOINs
6. **Batch Carefully**: Only batch to same partition

### Example Schema

```sql
-- Time-series data
CREATE TABLE events (
    sensor_id TEXT,
    event_time TIMESTAMP,
    event_type TEXT,
    value DOUBLE,
    PRIMARY KEY (sensor_id, event_time)
) WITH CLUSTERING ORDER BY (event_time DESC);

-- User data with materialized view
CREATE TABLE users_by_id (
    user_id UUID PRIMARY KEY,
    username TEXT,
    email TEXT,
    created_at TIMESTAMP
);

CREATE MATERIALIZED VIEW users_by_email AS
    SELECT * FROM users_by_id
    WHERE email IS NOT NULL
    PRIMARY KEY (email, user_id);
```

## Performance Tuning

The container is configured with:
- 512MB heap (suitable for testing)
- Single node (no replication)
- SimpleStrategy for replication

For production, increase resources:

```yaml
environment:
  - MAX_HEAP_SIZE=4G
  - HEAP_NEWSIZE=800M
```

## Stop Cassandra

```bash
docker compose down
```

## Backup and Restore

```bash
# Take snapshot
docker compose exec cassandra nodetool snapshot testdb

# List snapshots
docker compose exec cassandra nodetool listsnapshots

# Clear snapshot
docker compose exec cassandra nodetool clearsnapshot testdb
```

## Monitoring

```bash
# Real-time statistics
docker compose exec cassandra nodetool tablestats

# Thread pool stats
docker compose exec cassandra nodetool tpstats

# Heap memory usage
docker compose exec cassandra nodetool info | grep "Heap Memory"

# Check logs
docker compose logs -f cassandra

# JMX monitoring (port 7199)
# Use JConsole or similar JMX client
```

## Use Cases for Fess

1. **Large-scale Data**: Index data from distributed Cassandra clusters
2. **Time-series**: Search time-series event data
3. **IoT Data**: Index sensor readings and logs
4. **User Activity**: Search user action logs
5. **Message Archives**: Search chat or email messages

## Integration Patterns

### Pattern 1: Full Table Scan

Read all rows from table (use pagination):
```sql
SELECT * FROM documents LIMIT 1000;
-- Use paging state for next batch
```

### Pattern 2: Query by Partition

Query specific partitions:
```sql
SELECT * FROM documents WHERE partition_key = 'value';
```

### Pattern 3: Token Range Queries

Distribute workload across token ranges:
```sql
SELECT * FROM documents WHERE token(id) > <start> AND token(id) <= <end>;
```

## Security

```bash
# Enable authentication (requires restart)
docker compose exec cassandra cqlsh -e "
ALTER KEYSPACE system_auth
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};"

# Create new user
docker compose exec cassandra cqlsh -u cassandra -p cassandra -e "
CREATE USER fess_user WITH PASSWORD 'fess_password';"

# Grant permissions
docker compose exec cassandra cqlsh -u cassandra -p cassandra -e "
GRANT SELECT ON KEYSPACE testdb TO fess_user;"
```

## Troubleshooting

### Container exits immediately

Increase Docker memory to at least 2GB:
- Docker Desktop: Settings → Resources → Memory

### "Cannot allocate memory"

Reduce heap size in compose.yaml:

```yaml
environment:
  - MAX_HEAP_SIZE=256M
  - HEAP_NEWSIZE=64M
```

### CQL connection refused

Wait for Cassandra to fully start (60-90 seconds):

```bash
docker compose logs -f cassandra
# Wait for "Starting listening for CQL clients"
```

### Slow queries

1. Check table design (proper partition keys)
2. Avoid ALLOW FILTERING
3. Create appropriate indexes
4. Use prepared statements

## Notes

- **Port 9042**: CQL native protocol
- **Port 7199**: JMX monitoring
- **Memory**: Requires minimum 2GB RAM
- **Startup Time**: 60-90 seconds on first run
- **Data Persistence**: Stored in Docker volume `cassandra_data`
- **Replication**: Configured for single node (testing)
- **Consistency**: ALL for single node (doesn't affect testing)

## Resources

- [Cassandra Documentation](https://cassandra.apache.org/doc/latest/)
- [CQL Reference](https://cassandra.apache.org/doc/latest/cassandra/cql/)
- [Data Modeling Guide](https://cassandra.apache.org/doc/latest/cassandra/data_modeling/)
- [DataStax Documentation](https://docs.datastax.com/)
