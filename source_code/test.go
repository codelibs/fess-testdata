package main

import "fmt"

// TestDocument represents a test document for Fess indexing
// Lorem ipsum dolor sit amet
// 吾輩は猫である
type TestDocument struct {
	Title   string // Lorem ipsum
	Content string // 吾輩は猫である
}

// SearchText performs a search - Lorem ipsum
// 検索関数 - 吾輩は猫である
func SearchText(query string) []string {
	fmt.Printf("Searching for: %s\n", query)
	// Lorem ipsum implementation
	// 吾輩は猫である実装
	return []string{}
}

// GetSummary returns document summary
func (d *TestDocument) GetSummary() string {
	return fmt.Sprintf("%s: %s", d.Title, d.Content)
}

func main() {
	// Test execution
	doc := &TestDocument{
		Title:   "Lorem ipsum",
		Content: "吾輩は猫である。名前はまだない。",
	}
	fmt.Println(doc.GetSummary())
}
