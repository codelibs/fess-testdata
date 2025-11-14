-- Oracle Database initialization script
-- Automatically executed on container startup

-- Switch to pluggable database
ALTER SESSION SET CONTAINER = XEPDB1;

-- Create documents table
CREATE TABLE testuser.documents (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR2(255) NOT NULL,
    content CLOB,
    url VARCHAR2(500),
    tags VARCHAR2(1000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_doc_title ON testuser.documents(title);
CREATE INDEX idx_doc_created ON testuser.documents(created_at);

-- Insert sample data
INSERT INTO testuser.documents (title, content, url, tags) VALUES (
    'Oracle Database Test Document 1',
    'This is a test document for Fess crawling. Oracle Database is the world''s leading enterprise database management system, providing high performance, scalability, and security.',
    'http://localhost/doc1',
    'oracle,database,enterprise'
);

INSERT INTO testuser.documents (title, content, url, tags) VALUES (
    'Oracle Database Test Document 2',
    'Oracle Database 21c Express Edition provides powerful features for development and testing. It includes support for JSON, XML, and advanced SQL capabilities.',
    'http://localhost/doc2',
    'oracle,features,sql'
);

INSERT INTO testuser.documents (title, content, url, tags) VALUES (
    'Oracle Database Test Document 3',
    'Oracle Database offers multi-model capabilities including relational, JSON, XML, spatial, and graph data. It is used by thousands of organizations worldwide.',
    'http://localhost/doc3',
    'oracle,multi-model,enterprise'
);

INSERT INTO testuser.documents (title, content, url, tags) VALUES (
    'テストドキュメント4',
    'Oracle DatabaseはマルチバイトUnicode（UTF-8）を完全サポートしており、日本語、中国語、韓国語などのデータを問題なく扱えます。',
    'http://localhost/doc4',
    '日本語,Oracle,データベース'
);

INSERT INTO testuser.documents (title, content, url, tags) VALUES (
    'Oracle PL/SQL Programming',
    'PL/SQL is Oracle''s procedural extension to SQL. It provides powerful programming constructs including variables, loops, conditions, and exception handling.',
    'http://localhost/doc5',
    'oracle,plsql,programming'
);

INSERT INTO testuser.documents (title, content, url, tags) VALUES (
    'Oracle Database Security',
    'Oracle Database provides comprehensive security features including encryption, access control, auditing, and data masking to protect sensitive information.',
    'http://localhost/doc6',
    'oracle,security,encryption'
);

INSERT INTO testuser.documents (title, content, url, tags) VALUES (
    'Oracle Database Performance',
    'Oracle Database includes advanced performance features such as in-memory processing, query optimization, partitioning, and automatic storage management.',
    'http://localhost/doc7',
    'oracle,performance,optimization'
);

COMMIT;

-- Grant additional privileges if needed
-- GRANT SELECT ON testuser.documents TO public;

-- Display results
SELECT COUNT(*) AS "Total Documents" FROM testuser.documents;
SELECT id, title, tags FROM testuser.documents ORDER BY id;

EXIT;
