#!/usr/bin/env ruby
# Test Ruby file for Fess search indexing
# テスト用Rubyファイル

# Search function - Lorem ipsum dolor sit amet
# 検索関数 - 吾輩は猫である
def search_text(query)
  puts "Searching for: #{query}"
  # Lorem ipsum implementation
  # 吾輩は猫である実装
  []
end

# Test document class for indexing
class TestDocument
  attr_accessor :title, :content

  def initialize(title, content)
    @title = title  # Lorem ipsum
    @content = content  # 吾輩は猫である
  end

  def summary
    "#{@title}: #{@content}"
  end
end

# Test execution
if __FILE__ == $0
  doc = TestDocument.new("Lorem ipsum", "吾輩は猫である。名前はまだない。")
  puts doc.summary
end
