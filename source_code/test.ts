/**
 * Test TypeScript file for Fess search indexing
 * テスト用TypeScriptファイル
 */

/**
 * TestDocument interface
 * Lorem ipsum dolor sit amet
 * 吾輩は猫である
 */
interface TestDocument {
    title: string;   // Lorem ipsum
    content: string; // 吾輩は猫である
}

/**
 * Search function - Lorem ipsum dolor sit amet
 * 検索関数 - 吾輩は猫である
 */
function searchText(query: string): string[] {
    console.log(`Searching for: ${query}`);
    // Lorem ipsum implementation
    // 吾輩は猫である実装
    return [];
}

/**
 * TestDocument class for indexing
 */
class TestDocumentImpl implements TestDocument {
    constructor(
        public title: string,
        public content: string
    ) {}

    getSummary(): string {
        return `${this.title}: ${this.content}`;
    }
}

// Test execution
const doc = new TestDocumentImpl("Lorem ipsum", "吾輩は猫である。名前はまだない。");
console.log(doc.getSummary());
