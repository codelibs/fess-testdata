#!/bin/bash
# Apache Solr data initialization script

SOLR_URL="http://localhost:8983/solr/documents"

echo "Waiting for Solr to be ready..."
for i in {1..30}; do
    if curl -s "$SOLR_URL/admin/ping" > /dev/null 2>&1; then
        echo "Solr is ready!"
        break
    fi
    echo "Waiting... ($i/30)"
    sleep 2
done

echo "Loading sample documents..."

# Index documents using JSON
curl -X POST "$SOLR_URL/update/json/docs" \
  -H 'Content-Type: application/json' -d '[
    {
      "id": "doc1",
      "title": "Apache Solr Test Document 1",
      "content": "This is a test document for Fess crawling. Apache Solr is an enterprise search platform written in Java, based on Apache Lucene.",
      "url": "http://localhost/doc1",
      "tags": ["solr", "search", "lucene"],
      "created_at": "2025-01-01T00:00:00Z"
    },
    {
      "id": "doc2",
      "title": "Apache Solr Test Document 2",
      "content": "Solr provides distributed indexing, replication, load-balanced querying, and automatic failover and recovery.",
      "url": "http://localhost/doc2",
      "tags": ["solr", "distributed", "search"],
      "created_at": "2025-01-02T00:00:00Z"
    },
    {
      "id": "doc3",
      "title": "Apache Solr Test Document 3",
      "content": "Solr supports faceted search, highlighting, spatial search, and rich document parsing with Apache Tika.",
      "url": "http://localhost/doc3",
      "tags": ["solr", "faceting", "tika"],
      "created_at": "2025-01-03T00:00:00Z"
    },
    {
      "id": "doc4",
      "title": "テストドキュメント4",
      "content": "Apache Solrは日本語を含む多言語の全文検索をサポートします。形態素解析エンジンと統合することで高精度な日本語検索が実現できます。",
      "url": "http://localhost/doc4",
      "tags": ["日本語", "テスト", "検索"],
      "created_at": "2025-01-04T00:00:00Z"
    },
    {
      "id": "doc5",
      "title": "Solr Faceting",
      "content": "Faceted search allows users to navigate search results by applying multiple filters based on faceted classification of documents.",
      "url": "http://localhost/doc5",
      "tags": ["solr", "faceting", "filters"],
      "created_at": "2025-01-05T00:00:00Z"
    },
    {
      "id": "doc6",
      "title": "Solr Query Syntax",
      "content": "Solr supports powerful query syntax including boolean operators, phrase queries, wildcards, fuzzy search, and proximity searches.",
      "url": "http://localhost/doc6",
      "tags": ["solr", "query", "syntax"],
      "created_at": "2025-01-06T00:00:00Z"
    },
    {
      "id": "doc7",
      "title": "SolrCloud",
      "content": "SolrCloud provides distributed indexing and searching capabilities, with features like automatic failover, load balancing, and centralized configuration.",
      "url": "http://localhost/doc7",
      "tags": ["solr", "solrcloud", "distributed"],
      "created_at": "2025-01-07T00:00:00Z"
    }
  ]'

echo ""
echo "Committing documents..."
curl "$SOLR_URL/update?commit=true"

echo ""
echo ""
echo "Data loading completed!"
echo ""
echo "Verifying documents..."
curl -s "$SOLR_URL/select?q=*:*&rows=0&wt=json&indent=true" | grep numFound

echo ""
echo "Sample search..."
curl -s "$SOLR_URL/select?q=solr&rows=3&wt=json&indent=true" | head -40

echo ""
echo ""
echo "Access Solr Admin UI: http://localhost:8983/solr/"
echo "Core name: documents"
