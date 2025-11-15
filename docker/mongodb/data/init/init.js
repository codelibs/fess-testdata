// MongoDB Initialization Script
// This script initializes the testdb database with sample documents

db = db.getSiblingDB('testdb');

// Create documents collection with sample data
db.documents.insertMany([
  {
    title: "MongoDB Test Document 1",
    content: "This is a test document for Fess crawling. MongoDB is a document-oriented NoSQL database that stores data in flexible, JSON-like documents.",
    url: "http://localhost/doc1",
    tags: ["test", "mongodb", "nosql"],
    author: "Test User",
    created_at: new Date(),
    updated_at: new Date()
  },
  {
    title: "MongoDB Test Document 2",
    content: "Another test document with different content. MongoDB supports rich queries, indexing, and aggregation operations for data analysis.",
    url: "http://localhost/doc2",
    tags: ["test", "database", "document"],
    author: "Test User",
    created_at: new Date(),
    updated_at: new Date()
  },
  {
    title: "MongoDB Test Document 3",
    content: "Third test document. Fess is an open source enterprise search server that can crawl and index data from various sources including MongoDB.",
    url: "http://localhost/doc3",
    tags: ["test", "fess", "search"],
    author: "Test User",
    created_at: new Date(),
    updated_at: new Date()
  },
  {
    title: "テストドキュメント4",
    content: "日本語のテストドキュメントです。MongoDBはUTF-8エンコーディングをネイティブサポートしており、多言語のコンテンツを扱うことができます。",
    url: "http://localhost/doc4",
    tags: ["日本語", "テスト", "MongoDB"],
    author: "テストユーザー",
    created_at: new Date(),
    updated_at: new Date()
  },
  {
    title: "Sample Article 5",
    content: "This document demonstrates MongoDB crawling capabilities. You can use flexible queries to select specific documents for indexing based on various criteria.",
    url: "http://localhost/doc5",
    tags: ["sample", "crawling", "indexing"],
    author: "Test User",
    created_at: new Date(),
    updated_at: new Date()
  }
]);

// Create indexes for better query performance
db.documents.createIndex({ title: 1 });
db.documents.createIndex({ tags: 1 });
db.documents.createIndex({ created_at: -1 });
db.documents.createIndex({ url: 1 }, { unique: true });

print("MongoDB test database initialized successfully!");
print("Total documents inserted: " + db.documents.countDocuments());
