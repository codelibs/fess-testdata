/**
 * Test Kotlin file for Fess search indexing
 * テスト用Kotlinファイル
 */

/**
 * TestDocument data class
 * Lorem ipsum dolor sit amet
 * 吾輩は猫である
 */
data class TestDocument(
    val title: String,   // Lorem ipsum
    val content: String  // 吾輩は猫である
) {
    /**
     * Get document summary
     */
    fun getSummary(): String {
        return "$title: $content"
    }
}

/**
 * Search function - Lorem ipsum dolor sit amet
 * 検索関数 - 吾輩は猫である
 */
fun searchText(query: String): List<String> {
    println("Searching for: $query")
    // Lorem ipsum implementation
    // 吾輩は猫である実装
    return emptyList()
}

fun main() {
    // Test execution
    val doc = TestDocument("Lorem ipsum", "吾輩は猫である。名前はまだない。")
    println(doc.getSummary())
}
