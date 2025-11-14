#!/bin/bash
# Cassandra data initialization script

echo "Waiting for Cassandra to be ready..."
echo "This may take 60-90 seconds on first startup..."
echo ""

for i in {1..90}; do
    if docker compose exec -T cassandra cqlsh -e "SELECT cluster_name FROM system.local;" > /dev/null 2>&1; then
        echo "Cassandra is ready!"
        break
    fi
    if [ $((i % 10)) -eq 0 ]; then
        echo "Still waiting... ($i/90 seconds)"
    fi
    sleep 1
done

echo ""
echo "Creating keyspace and table..."

docker compose exec -T cassandra cqlsh <<'EOF'
-- Create keyspace
CREATE KEYSPACE IF NOT EXISTS testdb
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

-- Use keyspace
USE testdb;

-- Create documents table
CREATE TABLE IF NOT EXISTS documents (
    id UUID PRIMARY KEY,
    title TEXT,
    content TEXT,
    url TEXT,
    tags SET<TEXT>,
    created_at TIMESTAMP
);

-- Create index on created_at for range queries
CREATE INDEX IF NOT EXISTS ON documents (created_at);

-- Insert sample data
INSERT INTO documents (id, title, content, url, tags, created_at)
VALUES (uuid(), 'Cassandra Test Document 1',
        'This is a test document for Fess crawling. Apache Cassandra is a highly scalable, distributed NoSQL database.',
        'http://localhost/doc1',
        {'cassandra', 'nosql', 'distributed'},
        toTimestamp(now()));

INSERT INTO documents (id, title, content, url, tags, created_at)
VALUES (uuid(), 'Cassandra Test Document 2',
        'Cassandra provides high availability with no single point of failure. It uses a peer-to-peer architecture.',
        'http://localhost/doc2',
        {'cassandra', 'availability', 'architecture'},
        toTimestamp(now()));

INSERT INTO documents (id, title, content, url, tags, created_at)
VALUES (uuid(), 'Cassandra Test Document 3',
        'Cassandra uses CQL (Cassandra Query Language), which is similar to SQL but designed for distributed systems.',
        'http://localhost/doc3',
        {'cassandra', 'cql', 'query'},
        toTimestamp(now()));

INSERT INTO documents (id, title, content, url, tags, created_at)
VALUES (uuid(), 'テストドキュメント4',
        'Apache CassandraはNetflix、Apple、Instagram等の大規模システムで使用されている分散データベースです。',
        'http://localhost/doc4',
        {'日本語', 'テスト', 'Cassandra'},
        toTimestamp(now()));

INSERT INTO documents (id, title, content, url, tags, created_at)
VALUES (uuid(), 'Cassandra Scalability',
        'Cassandra provides linear scalability. You can add nodes to the cluster without any downtime or application changes.',
        'http://localhost/doc5',
        {'cassandra', 'scalability', 'performance'},
        toTimestamp(now()));

INSERT INTO documents (id, title, content, url, tags, created_at)
VALUES (uuid(), 'Cassandra Data Model',
        'Cassandra uses a wide column store model. Data is organized into keyspaces, tables, and rows with flexible columns.',
        'http://localhost/doc6',
        {'cassandra', 'data-model', 'architecture'},
        toTimestamp(now()));

INSERT INTO documents (id, title, content, url, tags, created_at)
VALUES (uuid(), 'Cassandra Consistency',
        'Cassandra offers tunable consistency levels from ONE to ALL, allowing trade-offs between consistency and availability.',
        'http://localhost/doc7',
        {'cassandra', 'consistency', 'cap-theorem'},
        toTimestamp(now()));

-- Show inserted data
SELECT COUNT(*) FROM documents;
SELECT id, title, tags FROM documents;

EOF

echo ""
echo "Data loading completed!"
echo ""
echo "You can now query the data:"
echo "  docker compose exec cassandra cqlsh -e 'SELECT * FROM testdb.documents;'"
echo ""
echo "Or connect interactively:"
echo "  docker compose exec cassandra cqlsh"
echo "  USE testdb;"
echo "  SELECT * FROM documents;"
