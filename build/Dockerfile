# Test Dockerfile for Fess search indexing
# テスト用Dockerfile
# Lorem ipsum dolor sit amet
# 吾輩は猫である

FROM ubuntu:22.04

# Metadata - メタデータ
LABEL maintainer="Fess Test Team"
LABEL description="Lorem ipsum dolor sit amet, consectetur adipiscing elit."
LABEL version="1.0.0"
LABEL test_content="吾輩は猫である。名前はまだない。"

# Environment variables - 環境変数
ENV APP_NAME="Fess Test Application"
ENV APP_VERSION="1.0.0"
ENV JAPANESE_TEXT="吾輩は猫である"
ENV LATIN_TEXT="Lorem ipsum dolor sit amet"

# Update and install dependencies - 依存関係のインストール
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    vim \
    git \
    # Lorem ipsum packages
    python3 \
    python3-pip \
    # 吾輩は猫である - Japanese support
    language-pack-ja \
    && rm -rf /var/lib/apt/lists/*

# Set working directory - 作業ディレクトリの設定
WORKDIR /app

# Copy application files - アプリケーションファイルのコピー
COPY . /app/

# Install Python dependencies - Python依存関係のインストール
# Lorem ipsum installation
RUN pip3 install --no-cache-dir \
    requests \
    pytest

# Create test directories - テストディレクトリの作成
RUN mkdir -p /app/data /app/logs /app/config

# Add test data - テストデータの追加
RUN echo "Lorem ipsum dolor sit amet" > /app/data/test.txt && \
    echo "吾輩は猫である。名前はまだない。" >> /app/data/test.txt

# Expose port - ポートの公開
EXPOSE 8080

# Health check - ヘルスチェック
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8080/health || exit 1

# Default command - デフォルトコマンド
CMD ["python3", "-m", "http.server", "8080"]
