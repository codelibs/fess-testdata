Elasticsearch Test Environment
===============================

## Overview

This environment provides Elasticsearch, a distributed search and analytics engine for testing Fess integration and search capabilities.

## Run Elasticsearch

```bash
docker compose up -d
```

Wait for Elasticsearch to start (takes 20-30 seconds on first run).

## Check Status

```bash
# Check if Elasticsearch is ready
curl http://localhost:9200/

# Check cluster health
curl http://localhost:9200/_cluster/health?pretty
```

## Initialize Test Data

Load sample documents using the REST API:

```bash
# Create index with mapping
curl -X PUT "http://localhost:9200/documents" -H 'Content-Type: application/json' -d'{
  "mappings": {
    "properties": {
      "title": { "type": "text" },
      "content": { "type": "text" },
      "url": { "type": "keyword" },
      "created_at": { "type": "date" }
    }
  }
}'

# Index documents
curl -X POST "http://localhost:9200/documents/_doc/1" -H 'Content-Type: application/json' -d'{
  "title": "Elasticsearch Test Document 1",
  "content": "This is a test document for Fess crawling. Elasticsearch is a distributed, RESTful search and analytics engine.",
  "url": "http://localhost/doc1",
  "created_at": "2025-01-01T00:00:00Z"
}'
```

Or use the provided initialization script:

```bash
chmod +x data/load_data.sh
./data/load_data.sh
```

## Fess Configuration

### Data Store Configuration

Elasticsearch can be configured as a data source in Fess:

| Name | Value |
|:-----|:------|
| Handler | Custom Elasticsearch DataStore |
| Parameter | url=http://localhost:9200<br>index=documents<br>query={"query": {"match_all": {}}} |

**Note**: Fess itself uses Elasticsearch internally, so integration is straightforward. You can:
1. Use Elasticsearch as an external data source
2. Configure as a federated search target
3. Import documents via bulk API

### Example Queries

```bash
# Search all documents
curl "http://localhost:9200/documents/_search?pretty"

# Search with query
curl -X GET "http://localhost:9200/documents/_search" -H 'Content-Type: application/json' -d'{
  "query": {
    "match": {
      "content": "elasticsearch"
    }
  }
}'

# Aggregation query
curl -X GET "http://localhost:9200/documents/_search" -H 'Content-Type: application/json' -d'{
  "size": 0,
  "aggs": {
    "documents_by_date": {
      "date_histogram": {
        "field": "created_at",
        "calendar_interval": "month"
      }
    }
  }
}'
```

## Database Connection

- **Host**: localhost
- **HTTP Port**: 9200
- **Transport Port**: 9300
- **Protocol**: HTTP/REST
- **Security**: Disabled for testing

## Manual Operations

### Basic Commands

```bash
# Cluster info
curl "http://localhost:9200/"

# Cluster health
curl "http://localhost:9200/_cluster/health?pretty"

# List all indices
curl "http://localhost:9200/_cat/indices?v"

# Create index
curl -X PUT "http://localhost:9200/myindex"

# Index document (auto ID)
curl -X POST "http://localhost:9200/myindex/_doc" -H 'Content-Type: application/json' -d'{
  "title": "My Document",
  "content": "Document content here"
}'

# Index document (specific ID)
curl -X PUT "http://localhost:9200/myindex/_doc/1" -H 'Content-Type: application/json' -d'{
  "title": "Document 1",
  "content": "Content here"
}'

# Get document
curl "http://localhost:9200/myindex/_doc/1?pretty"

# Update document
curl -X POST "http://localhost:9200/myindex/_update/1" -H 'Content-Type: application/json' -d'{
  "doc": {
    "content": "Updated content"
  }
}'

# Delete document
curl -X DELETE "http://localhost:9200/myindex/_doc/1"

# Search
curl -X GET "http://localhost:9200/myindex/_search?q=title:document&pretty"

# Delete index
curl -X DELETE "http://localhost:9200/myindex"
```

### Bulk Operations

```bash
# Bulk index multiple documents
curl -X POST "http://localhost:9200/_bulk" -H 'Content-Type: application/x-ndjson' -d'
{"index":{"_index":"documents","_id":"1"}}
{"title":"Doc 1","content":"Content 1"}
{"index":{"_index":"documents","_id":"2"}}
{"title":"Doc 2","content":"Content 2"}
'
```

### Advanced Queries

```bash
# Full-text search with highlighting
curl -X GET "http://localhost:9200/documents/_search" -H 'Content-Type: application/json' -d'{
  "query": {
    "match": {
      "content": "elasticsearch"
    }
  },
  "highlight": {
    "fields": {
      "content": {}
    }
  }
}'

# Boolean query
curl -X GET "http://localhost:9200/documents/_search" -H 'Content-Type: application/json' -d'{
  "query": {
    "bool": {
      "must": [
        {"match": {"content": "test"}}
      ],
      "filter": [
        {"range": {"created_at": {"gte": "2025-01-01"}}}
      ]
    }
  }
}'

# Aggregations
curl -X GET "http://localhost:9200/documents/_search" -H 'Content-Type: application/json' -d'{
  "size": 0,
  "aggs": {
    "top_terms": {
      "terms": {
        "field": "title.keyword",
        "size": 10
      }
    }
  }
}'
```

## Elasticsearch Features

- **Full-text search**: Powerful text analysis and search
- **Distributed**: Scales horizontally across nodes
- **RESTful API**: All operations via HTTP
- **Real-time**: Near real-time search and indexing
- **Analytics**: Aggregations for data analysis
- **Schema-free**: Dynamic mapping for flexible documents
- **Multi-tenancy**: Support for multiple indices

## Performance Tuning

The container is configured with:
- Single-node mode (for testing)
- 512MB heap size (adjust for production)
- Security disabled (enable in production)

For production, configure in `compose.yaml`:

```yaml
environment:
  - cluster.name=my-cluster
  - "ES_JAVA_OPTS=-Xms2g -Xmx2g"
  - xpack.security.enabled=true
```

## Stop Elasticsearch

```bash
docker compose down
```

## Monitoring

```bash
# Node stats
curl "http://localhost:9200/_nodes/stats?pretty"

# Index stats
curl "http://localhost:9200/documents/_stats?pretty"

# Search performance
curl "http://localhost:9200/documents/_search?profile=true" -H 'Content-Type: application/json' -d'{
  "query": {"match_all": {}}
}'
```

## Integration with Fess

Since Fess uses Elasticsearch internally:

1. **As Data Source**: Import external Elasticsearch indices into Fess
2. **Federated Search**: Configure as remote search target
3. **Data Migration**: Use reindex API to copy data between clusters

Example reindex from external Elasticsearch to Fess:

```bash
# In Fess's Elasticsearch
curl -X POST "http://fess-es:9200/_reindex" -H 'Content-Type: application/json' -d'{
  "source": {
    "remote": {
      "host": "http://localhost:9200"
    },
    "index": "documents"
  },
  "dest": {
    "index": "fess.documents"
  }
}'
```

## Notes

- **Port 9200**: HTTP REST API
- **Port 9300**: Internal transport (cluster communication)
- **Security**: Disabled for easy testing
- **Data Persistence**: Stored in Docker volume `es_data`
- **Memory**: Requires at least 2GB RAM (configured for 1GB total)
- **Version**: Elasticsearch 8.x

## Troubleshooting

### Out of memory

Increase heap size in compose.yaml:

```yaml
environment:
  - "ES_JAVA_OPTS=-Xms1g -Xmx1g"
```

### vm.max_map_count too low

On Linux host, increase map count:

```bash
sudo sysctl -w vm.max_map_count=262144
```

To make permanent, add to `/etc/sysctl.conf`:

```
vm.max_map_count=262144
```

### Connection refused

Wait for Elasticsearch to fully start (20-30 seconds):

```bash
docker compose logs -f elasticsearch
# Wait for "started" message
```

## Resources

- [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
- [REST API Reference](https://www.elastic.co/guide/en/elasticsearch/reference/current/rest-apis.html)
- [Query DSL](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html)
