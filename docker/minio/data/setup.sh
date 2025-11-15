#!/bin/bash
# MinIO setup and data initialization script

MINIO_ENDPOINT="http://localhost:9000"
MINIO_ALIAS="local"

echo "Waiting for MinIO to be ready..."
for i in {1..30}; do
    if curl -s "$MINIO_ENDPOINT/minio/health/live" > /dev/null 2>&1; then
        echo "MinIO is ready!"
        break
    fi
    echo "Waiting... ($i/30)"
    sleep 2
done

echo "Setting up MinIO client (mc) in container..."
docker run --rm --network host --entrypoint /bin/sh minio/mc -c "
# Configure MinIO alias
mc alias set $MINIO_ALIAS $MINIO_ENDPOINT minioadmin minioadmin123

# Create test bucket
echo 'Creating test-bucket...'
mc mb $MINIO_ALIAS/test-bucket

# Create sample files in container
mkdir -p /tmp/testdata
echo 'This is a test document for MinIO and Fess crawling.' > /tmp/testdata/doc1.txt
echo 'MinIO is a high-performance S3-compatible object storage.' > /tmp/testdata/doc2.txt
echo 'Fess can crawl and index files stored in object storage systems.' > /tmp/testdata/doc3.txt
echo 'MinIOはS3互換の高性能オブジェクトストレージです。' > /tmp/testdata/doc4.txt

cat > /tmp/testdata/sample.html <<'EOF'
<!DOCTYPE html>
<html>
<head><title>MinIO Test Page</title></head>
<body>
<h1>MinIO Test Content</h1>
<p>This is a test HTML file stored in MinIO object storage.</p>
<p>It can be crawled and indexed by Fess for full-text search.</p>
</body>
</html>
EOF

# Upload files to bucket
echo 'Uploading test files...'
mc cp /tmp/testdata/doc1.txt $MINIO_ALIAS/test-bucket/
mc cp /tmp/testdata/doc2.txt $MINIO_ALIAS/test-bucket/
mc cp /tmp/testdata/doc3.txt $MINIO_ALIAS/test-bucket/
mc cp /tmp/testdata/doc4.txt $MINIO_ALIAS/test-bucket/
mc cp /tmp/testdata/sample.html $MINIO_ALIAS/test-bucket/

# Create directory structure
mc cp /tmp/testdata/doc1.txt $MINIO_ALIAS/test-bucket/documents/doc1.txt
mc cp /tmp/testdata/doc2.txt $MINIO_ALIAS/test-bucket/documents/doc2.txt

# Make bucket publicly readable (for testing)
echo 'Setting bucket to public read...'
mc anonymous set download $MINIO_ALIAS/test-bucket

# List uploaded files
echo ''
echo 'Files in test-bucket:'
mc ls $MINIO_ALIAS/test-bucket/

echo ''
echo 'Setup completed!'
echo ''
echo 'MinIO Console: http://localhost:9001'
echo 'Username: minioadmin'
echo 'Password: minioadmin123'
echo ''
echo 'Access files via HTTP:'
echo 'http://localhost:9000/test-bucket/doc1.txt'
echo 'http://localhost:9000/test-bucket/sample.html'
"
