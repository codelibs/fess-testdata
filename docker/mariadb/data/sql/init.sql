-- MariaDB Test Data
-- This file is automatically executed on first startup

CREATE TABLE IF NOT EXISTS documents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_title (title),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample data
INSERT INTO documents (title, content, url) VALUES
    ('MariaDB Test Document 1', 'This is a test document for Fess crawling. MariaDB is a community-developed, commercially supported fork of MySQL.', 'http://localhost/doc1'),
    ('MariaDB Test Document 2', 'Another test document with different content. MariaDB offers better performance and additional features compared to MySQL.', 'http://localhost/doc2'),
    ('MariaDB Test Document 3', 'Third test document. MariaDB is fully compatible with MySQL and provides drop-in replacement capability.', 'http://localhost/doc3'),
    ('テストドキュメント4', '日本語のテストドキュメントです。MariaDBはUTF-8 MB4エンコーディングをサポートしており、絵文字も扱えます 😀', 'http://localhost/doc4'),
    ('Sample Article 5', 'This document demonstrates MariaDB crawling capabilities. MariaDB includes enhanced features like window functions and JSON support.', 'http://localhost/doc5'),
    ('Performance Test 6', 'MariaDB offers improved query optimizer and better execution plans for complex queries.', 'http://localhost/doc6'),
    ('Open Source Database', 'MariaDB is completely open source under GPL license, ensuring transparency and community collaboration.', 'http://localhost/doc7');

-- Create a view for testing
CREATE OR REPLACE VIEW active_documents AS
SELECT id, title, content, url, created_at
FROM documents
WHERE created_at > DATE_SUB(NOW(), INTERVAL 1 YEAR);

-- Add full-text search capability (optional)
-- ALTER TABLE documents ADD FULLTEXT INDEX ft_idx (title, content);

-- Show statistics
SELECT 'Documents table created and populated' AS status;
SELECT COUNT(*) AS total_documents FROM documents;
