CouchDB Test Environment
========================

## Overview

This environment provides Apache CouchDB, a document-oriented NoSQL database with HTTP REST API for testing Fess database crawling capabilities.

## Run CouchDB

```bash
docker compose up -d
```

Wait for CouchDB to initialize (takes about 10 seconds on first startup).

## Setup Cluster

CouchDB 3.x requires cluster setup on first run:

```bash
# Setup single-node cluster
curl -X POST "http://admin:admin123@localhost:5984/_cluster_setup" \
  -H "Content-Type: application/json" \
  -d '{"action": "finish_cluster"}'
```

Or use the web interface: http://localhost:5984/_utils/

## Initialize Test Data

Load sample documents using the REST API:

```bash
# Create database
curl -X PUT "http://admin:admin123@localhost:5984/testdb"

# Insert documents
curl -X POST "http://admin:admin123@localhost:5984/testdb" \
  -H "Content-Type: application/json" \
  -d '{
    "_id": "doc1",
    "type": "document",
    "title": "CouchDB Test Document 1",
    "content": "This is a test document for Fess crawling. CouchDB is a document-oriented NoSQL database.",
    "url": "http://localhost/doc1",
    "created_at": "2025-01-01T00:00:00Z"
  }'

curl -X POST "http://admin:admin123@localhost:5984/testdb" \
  -H "Content-Type: application/json" \
  -d '{
    "_id": "doc2",
    "type": "document",
    "title": "CouchDB Test Document 2",
    "content": "CouchDB uses HTTP REST API for all operations and stores data in JSON format.",
    "url": "http://localhost/doc2",
    "created_at": "2025-01-02T00:00:00Z"
  }'
```

Or use the provided initialization script:

```bash
chmod +x data/init/load_data.sh
./data/init/load_data.sh
```

## Fess Configuration

### Data Store Configuration

CouchDB uses HTTP REST API, so configuration depends on implementation:

| Name | Value |
|:-----|:------|
| Handler | Custom HTTP DataStore (requires implementation) |
| Parameter | url=http://localhost:5984/testdb/_all_docs?include_docs=true<br>username=admin<br>password=admin123<br>format=json |

**Note**: CouchDB integration may require custom implementation to:
1. Query documents via REST API
2. Parse JSON responses
3. Handle pagination with `limit` and `skip` parameters
4. Extract document fields for indexing

### Example REST API Queries

```bash
# Get all documents
curl "http://admin:admin123@localhost:5984/testdb/_all_docs?include_docs=true"

# Get specific document
curl "http://admin:admin123@localhost:5984/testdb/doc1"

# Query with Mango (MongoDB-style queries)
curl -X POST "http://admin:admin123@localhost:5984/testdb/_find" \
  -H "Content-Type: application/json" \
  -d '{
    "selector": {
      "type": "document"
    },
    "fields": ["_id", "title", "content", "url"],
    "limit": 100
  }'
```

## Database Connection

- **Host**: localhost
- **Port**: 5984
- **Username**: admin
- **Password**: admin123
- **Protocol**: HTTP/REST
- **Web UI**: http://localhost:5984/_utils/

## Manual Operations

### Using Web Interface (Fauxton)

Open http://localhost:5984/_utils/ in your browser:

1. Login with admin/admin123
2. Create/view databases
3. Add/edit documents
4. Run queries
5. Configure replication

### Using cURL

```bash
# Check server info
curl "http://admin:admin123@localhost:5984/"

# List all databases
curl "http://admin:admin123@localhost:5984/_all_dbs"

# Create database
curl -X PUT "http://admin:admin123@localhost:5984/mydb"

# Create document with auto-generated ID
curl -X POST "http://admin:admin123@localhost:5984/testdb" \
  -H "Content-Type: application/json" \
  -d '{"title": "New Document", "content": "Document content"}'

# Create document with specific ID
curl -X PUT "http://admin:admin123@localhost:5984/testdb/mydoc" \
  -H "Content-Type: application/json" \
  -d '{"title": "My Document", "content": "Content here"}'

# Get document
curl "http://admin:admin123@localhost:5984/testdb/mydoc"

# Update document (requires _rev)
curl -X PUT "http://admin:admin123@localhost:5984/testdb/mydoc" \
  -H "Content-Type: application/json" \
  -d '{"_rev": "1-abc123", "title": "Updated", "content": "New content"}'

# Delete document (requires _rev)
curl -X DELETE "http://admin:admin123@localhost:5984/testdb/mydoc?rev=1-abc123"

# Query all documents in database
curl "http://admin:admin123@localhost:5984/testdb/_all_docs?include_docs=true"

# Bulk insert
curl -X POST "http://admin:admin123@localhost:5984/testdb/_bulk_docs" \
  -H "Content-Type: application/json" \
  -d '{
    "docs": [
      {"_id": "doc3", "title": "Doc 3"},
      {"_id": "doc4", "title": "Doc 4"}
    ]
  }'
```

### Using Mango Queries (MongoDB-style)

```bash
# Create index
curl -X POST "http://admin:admin123@localhost:5984/testdb/_index" \
  -H "Content-Type: application/json" \
  -d '{
    "index": {
      "fields": ["title"]
    },
    "name": "title-index"
  }'

# Query with selector
curl -X POST "http://admin:admin123@localhost:5984/testdb/_find" \
  -H "Content-Type: application/json" \
  -d '{
    "selector": {
      "title": {
        "$regex": "(?i)test"
      }
    },
    "limit": 10
  }'
```

## CouchDB Features

- **Document-oriented**: JSON documents with flexible schema
- **REST API**: All operations via HTTP (GET, PUT, POST, DELETE)
- **ACID**: Multi-Version Concurrency Control (MVCC)
- **Replication**: Master-master replication support
- **Views**: MapReduce for aggregations and queries
- **Mango**: MongoDB-style declarative query language
- **Attachments**: Store binary files with documents
- **Changes Feed**: Real-time change notifications

## Views and MapReduce

Create a view to query documents:

```bash
curl -X PUT "http://admin:admin123@localhost:5984/testdb/_design/documents" \
  -H "Content-Type: application/json" \
  -d '{
    "views": {
      "by_title": {
        "map": "function(doc) { if(doc.title) { emit(doc.title, doc); } }"
      },
      "by_date": {
        "map": "function(doc) { if(doc.created_at) { emit(doc.created_at, doc); } }"
      }
    }
  }'

# Query view
curl "http://admin:admin123@localhost:5984/testdb/_design/documents/_view/by_title"
```

## Stop CouchDB

```bash
docker compose down
```

## Performance and Scaling

CouchDB is designed for:
- Offline-first applications
- Mobile and web sync
- Distributed systems with eventual consistency
- Environments requiring multi-master replication

## Notes

- **Port 5984**: Standard CouchDB HTTP port
- **Authentication**: Basic HTTP authentication
- **Data Format**: JSON documents
- **Versioning**: Every update creates new revision (_rev field)
- **Data Persistence**: Stored in Docker volume `couchdb_data`
- **Web UI**: Fauxton accessible at http://localhost:5984/_utils/
- **CORS**: May need to be configured for web applications

## Troubleshooting

### Cluster setup required

If you see errors about cluster not set up:

```bash
curl -X POST "http://admin:admin123@localhost:5984/_cluster_setup" \
  -H "Content-Type: application/json" \
  -d '{"action": "finish_cluster"}'
```

### Document conflicts

CouchDB uses MVCC, so updates require the current `_rev`:

```bash
# Get current revision
curl "http://admin:admin123@localhost:5984/testdb/mydoc" | jq '._rev'

# Use it in update
curl -X PUT "http://admin:admin123@localhost:5984/testdb/mydoc" \
  -d '{"_rev": "2-xyz", "updated": "content"}'
```

## Resources

- [CouchDB Documentation](https://docs.couchdb.org/)
- [CouchDB Guide](https://guide.couchdb.org/)
- [REST API Reference](https://docs.couchdb.org/en/stable/api/index.html)
