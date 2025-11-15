-- Microsoft SQL Server Test Data
-- Execute this after creating testdb database

USE testdb;
GO

-- Create documents table
IF OBJECT_ID('documents', 'U') IS NOT NULL
    DROP TABLE documents;
GO

CREATE TABLE documents (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    content NVARCHAR(MAX),
    url NVARCHAR(500),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    INDEX idx_title (title),
    INDEX idx_created_at (created_at)
);
GO

-- Insert sample data
INSERT INTO documents (title, content, url) VALUES
    (N'SQL Server Test Document 1',
     N'This is a test document for Fess crawling. Microsoft SQL Server is a relational database management system developed by Microsoft.',
     N'http://localhost/doc1'),
    (N'SQL Server Test Document 2',
     N'Another test document with different content. SQL Server supports T-SQL (Transact-SQL) which extends standard SQL.',
     N'http://localhost/doc2'),
    (N'SQL Server Test Document 3',
     N'Third test document. SQL Server provides enterprise-grade features including high availability, security, and performance.',
     N'http://localhost/doc3'),
    (N'テストドキュメント4',
     N'日本語のテストドキュメントです。SQL Serverは日本語を含む多言語をネイティブサポートしています。',
     N'http://localhost/doc4'),
    (N'Sample Article 5',
     N'This document demonstrates SQL Server crawling capabilities. SQL Server integrates well with .NET and Azure cloud services.',
     N'http://localhost/doc5'),
    (N'Enterprise Features',
     N'SQL Server offers advanced features like In-Memory OLTP, columnstore indexes, and Always On availability groups.',
     N'http://localhost/doc6'),
    (N'Business Intelligence',
     N'SQL Server includes built-in BI tools, reporting services (SSRS), and integration services (SSIS) for ETL operations.',
     N'http://localhost/doc7');
GO

-- Create a view
CREATE VIEW active_documents AS
SELECT id, title, content, url, created_at
FROM documents
WHERE created_at > DATEADD(YEAR, -1, GETDATE());
GO

-- Create a stored procedure for testing
CREATE PROCEDURE GetRecentDocuments
    @Days INT = 30
AS
BEGIN
    SELECT id, title, content, url, created_at
    FROM documents
    WHERE created_at > DATEADD(DAY, -@Days, GETDATE())
    ORDER BY created_at DESC;
END;
GO

-- Show statistics
PRINT 'Documents table created and populated';
SELECT COUNT(*) AS TotalDocuments FROM documents;
GO

-- Optional: Create full-text catalog and index for advanced search
/*
CREATE FULLTEXT CATALOG ftCatalog AS DEFAULT;
GO

CREATE FULLTEXT INDEX ON documents(title, content)
KEY INDEX PK__document__3213E83F
WITH STOPLIST = SYSTEM;
GO
*/

PRINT 'Database initialization completed successfully';
GO
