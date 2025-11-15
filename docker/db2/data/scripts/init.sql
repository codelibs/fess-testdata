-- IBM DB2 initialization script
-- Execute with: db2 -tvf init.sql

CONNECT TO testdb;

-- Create documents table
CREATE TABLE documents (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content CLOB(1M),
    url VARCHAR(500),
    tags VARCHAR(1000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_doc_title ON documents(title);
CREATE INDEX idx_doc_created ON documents(created_at);

-- Insert sample data
INSERT INTO documents (title, content, url, tags) VALUES (
    'IBM DB2 Test Document 1',
    'This is a test document for Fess crawling. IBM DB2 is a family of data management products, including the DB2 relational database.',
    'http://localhost/doc1',
    'db2,ibm,database'
);

INSERT INTO documents (title, content, url, tags) VALUES (
    'IBM DB2 Test Document 2',
    'DB2 provides enterprise-class database server with high availability, security, and performance. It supports both OLTP and analytics workloads.',
    'http://localhost/doc2',
    'db2,enterprise,performance'
);

INSERT INTO documents (title, content, url, tags) VALUES (
    'IBM DB2 Test Document 3',
    'DB2 includes advanced features such as BLU Acceleration for columnar processing, pureScale for high availability, and built-in JSON support.',
    'http://localhost/doc3',
    'db2,features,json'
);

INSERT INTO documents (title, content, url, tags) VALUES (
    'テストドキュメント4',
    'IBM DB2はUnicodeを完全サポートしており、日本語、中国語、韓国語などのマルチバイト文字を扱えます。',
    'http://localhost/doc4',
    '日本語,DB2,データベース'
);

INSERT INTO documents (title, content, url, tags) VALUES (
    'DB2 SQL Compatibility',
    'DB2 supports SQL PL (Procedural Language) which is similar to Oracle PL/SQL. It provides compatibility with other database systems.',
    'http://localhost/doc5',
    'db2,sql,compatibility'
);

INSERT INTO documents (title, content, url, tags) VALUES (
    'DB2 Performance Features',
    'DB2 includes advanced performance features like adaptive compression, index compression, multi-temperature data management, and workload management.',
    'http://localhost/doc6',
    'db2,performance,compression'
);

INSERT INTO documents (title, content, url, tags) VALUES (
    'DB2 Integration',
    'DB2 integrates well with IBM Watson, IBM Cloud, and other enterprise systems. It supports hybrid cloud deployments and containerization.',
    'http://localhost/doc7',
    'db2,integration,cloud'
);

COMMIT;

-- Display statistics
SELECT COUNT(*) AS "Total Documents" FROM documents;

-- Show first few rows
SELECT id, title, tags FROM documents ORDER BY id FETCH FIRST 10 ROWS ONLY;

TERMINATE;
