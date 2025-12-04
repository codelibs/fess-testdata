#!/usr/bin/env lua
-- Test Lua script for Fess search indexing
-- テスト用Luaスクリプト
-- Lorem ipsum dolor sit amet
-- 吾輩は猫である

-- Configuration - Lorem ipsum
local app_name = "Fess Test Application"
local version = "1.0.0"
local description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."

-- 日本語変数 - 吾輩は猫である
local japanese_text = "吾輩は猫である。名前はまだない。"

-- Function to search text - Lorem ipsum
local function search_text(query)
    print("Searching for: " .. query)
    -- Lorem ipsum implementation
    -- 吾輩は猫である実装
    return {}
end

-- Main execution - テストメイン処理
local function main()
    print("Starting " .. app_name .. " v" .. version)
    print(description)

    -- Test search - テスト検索
    search_text("Lorem ipsum")
    search_text(japanese_text)

    print("Test completed - テスト完了")
end

-- Run main function
main()
