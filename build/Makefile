# Test Makefile for Fess search indexing
# テスト用Makefile
# Lorem ipsum dolor sit amet
# 吾輩は猫である

# Variables - Lorem ipsum
APP_NAME = fess-test-app
VERSION = 1.0.0
BUILD_DIR = build
SRC_DIR = src
TEST_DIR = test

# 日本語コメント - 吾輩は猫である
DESCRIPTION = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."

# Default target - デフォルトターゲット
.PHONY: all
all: build test

# Build target - ビルドターゲット
.PHONY: build
build:
	@echo "Building $(APP_NAME) v$(VERSION)"
	@echo $(DESCRIPTION)
	@echo "Lorem ipsum build process"
	@echo "吾輩は猫である - ビルド処理"
	mkdir -p $(BUILD_DIR)

# Test target - テストターゲット
.PHONY: test
test:
	@echo "Running tests - テスト実行中"
	@echo "Lorem ipsum test execution"
	@echo "吾輩は猫である - テスト実行"

# Clean target - クリーンターゲット
.PHONY: clean
clean:
	@echo "Cleaning build directory - ビルドディレクトリをクリーン"
	rm -rf $(BUILD_DIR)

# Install target - インストールターゲット
.PHONY: install
install: build
	@echo "Installing $(APP_NAME) - インストール中"
	@echo "Lorem ipsum installation"
	@echo "吾輩は猫である - インストール"

# Help target - ヘルプターゲット
.PHONY: help
help:
	@echo "Available targets - 利用可能なターゲット:"
	@echo "  all     - Build and test (default) - ビルドとテスト"
	@echo "  build   - Build the application - アプリケーションビルド"
	@echo "  test    - Run tests - テスト実行"
	@echo "  clean   - Clean build directory - クリーン"
	@echo "  install - Install the application - インストール"
	@echo "  help    - Show this help - このヘルプを表示"
