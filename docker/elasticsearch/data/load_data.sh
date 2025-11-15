#!/bin/bash
# Elasticsearch data initialization script

ES_URL="http://localhost:9200"

echo "Waiting for Elasticsearch to be ready..."
for i in {1..60}; do
    if curl -s "$ES_URL/_cluster/health" > /dev/null 2>&1; then
        echo "Elasticsearch is ready!"
        break
    fi
    echo "Waiting... ($i/60)"
    sleep 2
done

echo "Creating 'documents' index with mapping..."
curl -X PUT "$ES_URL/documents" -H 'Content-Type: application/json' -d'{
  "mappings": {
    "properties": {
      "title": {
        "type": "text",
        "fields": {
          "keyword": { "type": "keyword" }
        }
      },
      "content": { "type": "text" },
      "url": { "type": "keyword" },
      "tags": { "type": "keyword" },
      "created_at": { "type": "date" }
    }
  },
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}'

echo ""
echo "Loading sample documents..."

# Bulk insert documents
curl -X POST "$ES_URL/_bulk" -H 'Content-Type: application/x-ndjson' -d'
{"index":{"_index":"documents","_id":"1"}}
{"title":"Elasticsearch Test Document 1","content":"This is a test document for Fess crawling. Elasticsearch is a distributed, RESTful search and analytics engine based on Apache Lucene.","url":"http://localhost/doc1","tags":["elasticsearch","search","test"],"created_at":"2025-01-01T00:00:00Z"}
{"index":{"_index":"documents","_id":"2"}}
{"title":"Elasticsearch Test Document 2","content":"Elasticsearch provides near real-time search and analytics for all types of data. It is horizontally scalable and highly available.","url":"http://localhost/doc2","tags":["elasticsearch","distributed","analytics"],"created_at":"2025-01-02T00:00:00Z"}
{"index":{"_index":"documents","_id":"3"}}
{"title":"Elasticsearch Test Document 3","content":"Elasticsearch uses inverted indices for fast full-text search. It supports complex queries, aggregations, and geospatial search.","url":"http://localhost/doc3","tags":["elasticsearch","indexing","queries"],"created_at":"2025-01-03T00:00:00Z"}
{"index":{"_index":"documents","_id":"4"}}
{"title":"テストドキュメント4","content":"Elasticsearchは日本語を含む多言語の全文検索をサポートします。形態素解析により高精度な日本語検索が可能です。","url":"http://localhost/doc4","tags":["日本語","テスト","検索"],"created_at":"2025-01-04T00:00:00Z"}
{"index":{"_index":"documents","_id":"5"}}
{"title":"Elasticsearch Aggregations","content":"Elasticsearch provides powerful aggregation framework for analytics. You can compute metrics, build histograms, and create complex nested aggregations.","url":"http://localhost/doc5","tags":["elasticsearch","aggregations","analytics"],"created_at":"2025-01-05T00:00:00Z"}
{"index":{"_index":"documents","_id":"6"}}
{"title":"Elasticsearch Query DSL","content":"The Query DSL is a flexible and expressive search language. It supports full-text queries, term-level queries, compound queries, and more.","url":"http://localhost/doc6","tags":["elasticsearch","query","dsl"],"created_at":"2025-01-06T00:00:00Z"}
{"index":{"_index":"documents","_id":"7"}}
{"title":"Elasticsearch Performance","content":"Elasticsearch is designed for speed. It uses caching, segment merging, and distributed execution to deliver fast search results even on large datasets.","url":"http://localhost/doc7","tags":["elasticsearch","performance","scalability"],"created_at":"2025-01-07T00:00:00Z"}
'

echo ""
echo ""
echo "Data loading completed!"
echo ""
echo "Verifying index..."
curl -s "$ES_URL/_cat/indices/documents?v"
echo ""
echo "Document count..."
curl -s "$ES_URL/documents/_count?pretty"
echo ""
echo "Sample search..."
curl -s "$ES_URL/documents/_search?q=elasticsearch&pretty" | head -30
echo ""
echo "Access Elasticsearch: http://localhost:9200/"
