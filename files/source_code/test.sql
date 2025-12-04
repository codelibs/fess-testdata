-- Test SQL file for Fess search indexing
-- テスト用SQLファイル
-- Lorem ipsum dolor sit amet
-- 吾輩は猫である

-- Create test documents table
CREATE TABLE test_documents (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL COMMENT 'Document title - Lorem ipsum',
    content TEXT COMMENT 'Document content - 吾輩は猫である',
    category VARCHAR(100),
    author VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert test data - Lorem ipsum
INSERT INTO test_documents (title, content, category, author) VALUES
('Lorem Ipsum', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', 'Document', 'Test User'),
('吾輩は猫である', '夏目漱石の小説。吾輩は猫である。名前はまだない。', 'Literature', '夏目漱石'),
('Test Document', 'This is a test document for Fess search indexing.', 'Test', 'Fess Team'),
('検索テスト', '全文検索エンジンのテストデータです。', 'Technology', '開発者');

-- Create index for full-text search - 吾輩は猫である
CREATE INDEX idx_title ON test_documents(title);
CREATE FULLTEXT INDEX idx_content ON test_documents(content);

-- Search query example - Lorem ipsum
SELECT id, title, content, author
FROM test_documents
WHERE MATCH(content) AGAINST('Lorem ipsum' IN NATURAL LANGUAGE MODE)
   OR MATCH(content) AGAINST('吾輩は猫である' IN NATURAL LANGUAGE MODE);

-- Update test data
UPDATE test_documents
SET content = CONCAT(content, ' - Updated content')
WHERE category = 'Test';

-- Delete old records
DELETE FROM test_documents
WHERE created_at < DATE_SUB(NOW(), INTERVAL 1 YEAR);
