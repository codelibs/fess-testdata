<?php
/**
 * Test PHP file for Fess search indexing
 * テスト用PHPファイル
 */

/**
 * Search function - Lorem ipsum dolor sit amet
 * 検索関数 - 吾輩は猫である
 */
function searchText($query) {
    echo "Searching for: " . $query . "\n";
    // Lorem ipsum implementation
    // 吾輩は猫である実装
    return array();
}

/**
 * Test document class for indexing
 */
class TestDocument {
    private $title;
    private $content;

    public function __construct($title, $content) {
        $this->title = $title;  // Lorem ipsum
        $this->content = $content;  // 吾輩は猫である
    }

    public function getSummary() {
        return $this->title . ": " . $this->content;
    }
}

// Test execution
$doc = new TestDocument("Lorem ipsum", "吾輩は猫である。名前はまだない。");
echo $doc->getSummary() . "\n";
?>
