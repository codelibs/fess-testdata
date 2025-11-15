Apache Solr Test Environment
=============================

## Overview

This environment provides Apache Solr, an enterprise search platform based on Apache Lucene, for testing Fess integration and search capabilities.

## Run Solr

```bash
docker compose up -d
```

Wait for Solr to start (takes 10-15 seconds on first run).

The container automatically creates a core named "documents".

## Check Status

```bash
# Check if Solr is ready
curl "http://localhost:8983/solr/admin/cores?action=STATUS&core=documents"

# Check core status
curl "http://localhost:8983/solr/documents/admin/ping"
```

## Initialize Test Data

Load sample documents using the REST API:

```bash
# Index a single document
curl -X POST "http://localhost:8983/solr/documents/update/json/docs" \
  -H 'Content-Type: application/json' -d '[
    {
      "id": "doc1",
      "title": "Apache Solr Test Document 1",
      "content": "This is a test document for Fess crawling. Apache Solr is an enterprise search platform based on Apache Lucene.",
      "url": "http://localhost/doc1",
      "created_at": "2025-01-01T00:00:00Z"
    }
  ]'

# Commit changes
curl "http://localhost:8983/solr/documents/update?commit=true"
```

Or use the provided initialization script:

```bash
chmod +x data/load_data.sh
./data/load_data.sh
```

## Fess Configuration

### Data Store Configuration

Solr can be configured as a data source in Fess:

| Name | Value |
|:-----|:------|
| Handler | Custom Solr DataStore |
| Parameter | url=http://localhost:8983/solr/documents<br>query=*:*<br>rows=100 |

**Note**: Integration requires custom implementation to:
1. Query Solr via REST API
2. Parse JSON/XML responses
3. Handle pagination with `start` and `rows` parameters

### Example Queries

```bash
# Search all documents
curl "http://localhost:8983/solr/documents/select?q=*:*&wt=json&indent=true"

# Search with query
curl "http://localhost:8983/solr/documents/select?q=content:solr&wt=json&indent=true"

# Faceted search
curl "http://localhost:8983/solr/documents/select?q=*:*&facet=true&facet.field=title&wt=json&indent=true"

# Filter query
curl "http://localhost:8983/solr/documents/select?q=*:*&fq=created_at:[2025-01-01T00:00:00Z TO NOW]&wt=json&indent=true"
```

## Database Connection

- **Host**: localhost
- **Port**: 8983
- **Core**: documents
- **Admin UI**: http://localhost:8983/solr/
- **Protocol**: HTTP/REST

## Manual Operations

### Admin UI

Open http://localhost:8983/solr/ in your browser to access:

1. Core Admin - Manage cores
2. Query Interface - Test queries
3. Schema Browser - View fields
4. Documents - Add/update/delete documents
5. Analysis - Test text analyzers

### Using cURL

```bash
# List all cores
curl "http://localhost:8983/solr/admin/cores?action=STATUS"

# Query documents
curl "http://localhost:8983/solr/documents/select?q=*:*"

# Add document
curl -X POST "http://localhost:8983/solr/documents/update/json/docs" \
  -H 'Content-Type: application/json' -d '[
    {
      "id": "new_doc",
      "title": "New Document",
      "content": "Document content here"
    }
  ]'

# Commit changes (make documents searchable)
curl "http://localhost:8983/solr/documents/update?commit=true"

# Get document by ID
curl "http://localhost:8983/solr/documents/get?id=doc1"

# Update document (atomic update)
curl -X POST "http://localhost:8983/solr/documents/update/json/docs" \
  -H 'Content-Type: application/json' -d '[
    {
      "id": "doc1",
      "content": {"set": "Updated content"}
    }
  ]'

# Delete document by ID
curl "http://localhost:8983/solr/documents/update?commit=true" \
  -H 'Content-Type: application/json' -d '{"delete": {"id": "doc1"}}'

# Delete by query
curl "http://localhost:8983/solr/documents/update?commit=true" \
  -H 'Content-Type: application/json' -d '{"delete": {"query": "title:test"}}'

# Optimize index
curl "http://localhost:8983/solr/documents/update?optimize=true"
```

### Search Queries

```bash
# Simple query
curl "http://localhost:8983/solr/documents/select?q=solr"

# Field-specific query
curl "http://localhost:8983/solr/documents/select?q=title:apache"

# Boolean query
curl "http://localhost:8983/solr/documents/select?q=title:apache AND content:lucene"

# Phrase query
curl "http://localhost:8983/solr/documents/select?q=content:\"search platform\""

# Wildcard query
curl "http://localhost:8983/solr/documents/select?q=title:apa*"

# Range query
curl "http://localhost:8983/solr/documents/select?q=created_at:[2025-01-01T00:00:00Z TO 2025-12-31T23:59:59Z]"

# Fuzzy query (similar terms)
curl "http://localhost:8983/solr/documents/select?q=content:lucen~"

# Boost query (increase relevance)
curl "http://localhost:8983/solr/documents/select?q=title:apache^2 content:solr"

# Filter query (cached, doesn't affect scoring)
curl "http://localhost:8983/solr/documents/select?q=*:*&fq=title:test"

# Sort results
curl "http://localhost:8983/solr/documents/select?q=*:*&sort=created_at desc"

# Pagination
curl "http://localhost:8983/solr/documents/select?q=*:*&start=0&rows=10"

# Return specific fields
curl "http://localhost:8983/solr/documents/select?q=*:*&fl=id,title,score"

# Highlighting
curl "http://localhost:8983/solr/documents/select?q=solr&hl=true&hl.fl=content"
```

### Faceting and Analytics

```bash
# Field faceting
curl "http://localhost:8983/solr/documents/select?q=*:*&facet=true&facet.field=title"

# Range faceting
curl "http://localhost:8983/solr/documents/select?q=*:*&facet=true&facet.range=created_at&facet.range.start=2025-01-01T00:00:00Z&facet.range.end=2025-12-31T23:59:59Z&facet.range.gap=%2B1MONTH"

# Query faceting
curl "http://localhost:8983/solr/documents/select?q=*:*&facet=true&facet.query=title:test&facet.query=title:apache"

# Stats
curl "http://localhost:8983/solr/documents/select?q=*:*&stats=true&stats.field=score"

# Group by field
curl "http://localhost:8983/solr/documents/select?q=*:*&group=true&group.field=title"
```

## Apache Solr Features

- **Full-text search**: Advanced text analysis and search
- **Faceting**: Count documents by field values
- **Highlighting**: Show matched terms in results
- **Spatial search**: Geospatial queries
- **Rich document**: Extract text from PDF, Word, etc.
- **Scalability**: SolrCloud for distributed search
- **Real-time**: Near real-time indexing
- **Schema**: Dynamic schema or managed schema

## Performance Tuning

The container uses default settings suitable for testing. For production, configure:

```yaml
environment:
  - SOLR_HEAP=1g
  - SOLR_JAVA_MEM=-Xms1g -Xmx1g
```

## Stop Solr

```bash
docker compose down
```

## Schema Management

View and modify the schema:

```bash
# View schema
curl "http://localhost:8983/solr/documents/schema"

# Add field
curl -X POST "http://localhost:8983/solr/documents/schema" \
  -H 'Content-Type: application/json' -d '{
    "add-field": {
      "name": "category",
      "type": "string",
      "stored": true
    }
  }'

# Add copy field
curl -X POST "http://localhost:8983/solr/documents/schema" \
  -H 'Content-Type: application/json' -d '{
    "add-copy-field": {
      "source": "title",
      "dest": "_text_"
    }
  }'
```

## Monitoring

```bash
# Core stats
curl "http://localhost:8983/solr/admin/cores?action=STATUS&core=documents&wt=json&indent=true"

# Index stats
curl "http://localhost:8983/solr/documents/admin/luke?numTerms=0&wt=json&indent=true"

# System info
curl "http://localhost:8983/solr/admin/info/system?wt=json&indent=true"

# JVM memory
curl "http://localhost:8983/solr/admin/info/system?wt=json&indent=true" | jq '.jvm.memory'
```

## Integration with Fess

Solr integration options:

1. **As Data Source**: Import Solr indices into Fess
2. **Federated Search**: Query Solr as external search engine
3. **Data Migration**: Export from Solr, import to Fess

## Notes

- **Port 8983**: Standard Solr port
- **Core**: "documents" core created automatically
- **Data Persistence**: Stored in Docker volume `solr_data`
- **Admin UI**: Available at http://localhost:8983/solr/
- **Memory**: Default 512MB heap (increase for production)
- **Commit**: Changes must be committed to become searchable

## Troubleshooting

### Documents not showing in search

Remember to commit after indexing:

```bash
curl "http://localhost:8983/solr/documents/update?commit=true"
```

### Out of memory

Increase heap size in compose.yaml:

```yaml
environment:
  - SOLR_HEAP=2g
```

### Core not found

Create core manually:

```bash
docker compose exec solr solr create_core -c documents
```

## Resources

- [Apache Solr Documentation](https://solr.apache.org/guide/)
- [Solr Reference Guide](https://solr.apache.org/guide/solr/latest/)
- [Query Syntax](https://solr.apache.org/guide/solr/latest/query-guide/standard-query-parser.html)
