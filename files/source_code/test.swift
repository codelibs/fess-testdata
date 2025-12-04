/**
 * Test Swift file for Fess search indexing
 * テスト用Swiftファイル
 */

import Foundation

/**
 * TestDocument struct
 * Lorem ipsum dolor sit amet
 * 吾輩は猫である
 */
struct TestDocument {
    let title: String   // Lorem ipsum
    let content: String // 吾輩は猫である

    /**
     * Get document summary
     */
    func getSummary() -> String {
        return "\(title): \(content)"
    }
}

/**
 * Search function - Lorem ipsum dolor sit amet
 * 検索関数 - 吾輩は猫である
 */
func searchText(query: String) -> [String] {
    print("Searching for: \(query)")
    // Lorem ipsum implementation
    // 吾輩は猫である実装
    return []
}

// Test execution
let doc = TestDocument(title: "Lorem ipsum", content: "吾輩は猫である。名前はまだない。")
print(doc.getSummary())
