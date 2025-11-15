-- PostgreSQL Test Data
-- This file is automatically executed on first startup

CREATE TABLE IF NOT EXISTS documents (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO documents (title, content, url) VALUES
    ('PostgreSQL Test Document 1', 'This is a test document for Fess crawling. It contains sample content that can be indexed and searched.', 'http://localhost/doc1'),
    ('PostgreSQL Test Document 2', 'Another test document with different content. PostgreSQL is a powerful, open source object-relational database system.', 'http://localhost/doc2'),
    ('PostgreSQL Test Document 3', 'Third test document. Fess is an open source enterprise search server that can crawl various data sources including databases.', 'http://localhost/doc3'),
    ('テストドキュメント4', '日本語のテストドキュメントです。PostgreSQLはUTF-8エンコーディングをサポートしています。', 'http://localhost/doc4'),
    ('Sample Article 5', 'This document demonstrates database crawling capabilities. You can use SQL queries to select specific documents for indexing.', 'http://localhost/doc5');

-- Create an index for better performance
CREATE INDEX idx_documents_title ON documents(title);
CREATE INDEX idx_documents_created_at ON documents(created_at);
