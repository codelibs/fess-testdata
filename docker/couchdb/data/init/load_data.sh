#!/bin/bash
# CouchDB data initialization script

COUCHDB_URL="http://admin:admin123@localhost:5984"

echo "Waiting for CouchDB to be ready..."
for i in {1..30}; do
    if curl -s "$COUCHDB_URL/_up" > /dev/null 2>&1; then
        echo "CouchDB is ready!"
        break
    fi
    sleep 1
done

echo "Setting up single-node cluster..."
curl -s -X POST "$COUCHDB_URL/_cluster_setup" \
  -H "Content-Type: application/json" \
  -d '{"action": "finish_cluster"}' > /dev/null

echo "Creating testdb database..."
curl -s -X PUT "$COUCHDB_URL/testdb" > /dev/null

echo "Loading sample documents..."

# Document 1
curl -s -X POST "$COUCHDB_URL/testdb" \
  -H "Content-Type: application/json" \
  -d '{
    "_id": "doc1",
    "type": "document",
    "title": "CouchDB Test Document 1",
    "content": "This is a test document for Fess crawling. Apache CouchDB is a document-oriented NoSQL database that uses JSON to store data.",
    "url": "http://localhost/doc1",
    "tags": ["couchdb", "nosql", "test"],
    "created_at": "2025-01-01T00:00:00Z"
  }' > /dev/null

# Document 2
curl -s -X POST "$COUCHDB_URL/testdb" \
  -H "Content-Type: application/json" \
  -d '{
    "_id": "doc2",
    "type": "document",
    "title": "CouchDB Test Document 2",
    "content": "CouchDB uses HTTP REST API for all operations. Every document has a unique ID and revision number.",
    "url": "http://localhost/doc2",
    "tags": ["couchdb", "rest", "api"],
    "created_at": "2025-01-02T00:00:00Z"
  }' > /dev/null

# Document 3
curl -s -X POST "$COUCHDB_URL/testdb" \
  -H "Content-Type: application/json" \
  -d '{
    "_id": "doc3",
    "type": "document",
    "title": "CouchDB Test Document 3",
    "content": "CouchDB supports multi-master replication and is designed for reliability and offline-first applications.",
    "url": "http://localhost/doc3",
    "tags": ["couchdb", "replication", "distributed"],
    "created_at": "2025-01-03T00:00:00Z"
  }' > /dev/null

# Document 4 (Japanese)
curl -s -X POST "$COUCHDB_URL/testdb" \
  -H "Content-Type: application/json" \
  -d '{
    "_id": "doc4",
    "type": "document",
    "title": "テストドキュメント4",
    "content": "CouchDBは日本語を含むUTF-8文字列を完全サポートします。JSONベースのドキュメント指向データベースです。",
    "url": "http://localhost/doc4",
    "tags": ["日本語", "テスト"],
    "created_at": "2025-01-04T00:00:00Z"
  }' > /dev/null

# Document 5
curl -s -X POST "$COUCHDB_URL/testdb" \
  -H "Content-Type: application/json" \
  -d '{
    "_id": "doc5",
    "type": "document",
    "title": "CouchDB MapReduce Views",
    "content": "CouchDB uses MapReduce to create views for querying and aggregating data efficiently.",
    "url": "http://localhost/doc5",
    "tags": ["couchdb", "mapreduce", "views"],
    "created_at": "2025-01-05T00:00:00Z"
  }' > /dev/null

echo "Creating design document with views..."
curl -s -X PUT "$COUCHDB_URL/testdb/_design/documents" \
  -H "Content-Type: application/json" \
  -d '{
    "views": {
      "by_title": {
        "map": "function(doc) { if(doc.title) { emit(doc.title, doc); } }"
      },
      "by_date": {
        "map": "function(doc) { if(doc.created_at) { emit(doc.created_at, doc); } }"
      },
      "by_tag": {
        "map": "function(doc) { if(doc.tags) { doc.tags.forEach(function(tag) { emit(tag, doc); }); } }"
      }
    }
  }' > /dev/null

echo "Creating Mango index..."
curl -s -X POST "$COUCHDB_URL/testdb/_index" \
  -H "Content-Type: application/json" \
  -d '{
    "index": {
      "fields": ["title", "created_at"]
    },
    "name": "title-date-index"
  }' > /dev/null

echo ""
echo "Data loading completed!"
echo ""
echo "Verifying..."
curl -s "$COUCHDB_URL/testdb/_all_docs" | jq '.total_rows'
echo "documents loaded"
echo ""
echo "Access Fauxton web UI: http://localhost:5984/_utils/"
echo "Username: admin"
echo "Password: admin123"
