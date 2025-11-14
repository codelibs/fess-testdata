MinIO Test Environment
======================

## Overview

This environment provides MinIO, a high-performance S3-compatible object storage system for testing Fess file crawling capabilities with cloud storage.

## Run MinIO

```bash
docker compose up -d
```

Wait for MinIO to start (takes 5-10 seconds).

## Access MinIO

- **Console UI**: http://localhost:9001
- **API Endpoint**: http://localhost:9000
- **Username**: minioadmin
- **Password**: minioadmin123

## Initialize Test Data

### Using Web Console

1. Open http://localhost:9001
2. Login with minioadmin/minioadmin123
3. Create bucket "test-bucket"
4. Upload test files

### Using MinIO Client (mc)

```bash
# Install mc client
docker run --rm -it --entrypoint=/bin/sh minio/mc

# Or on host
wget https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc

# Configure alias
./mc alias set local http://localhost:9000 minioadmin minioadmin123

# Create bucket
./mc mb local/test-bucket

# Upload files
./mc cp testfile.txt local/test-bucket/
./mc cp -r documents/ local/test-bucket/documents/

# List objects
./mc ls local/test-bucket

# Make bucket public (for testing)
./mc anonymous set download local/test-bucket
```

### Using AWS CLI

```bash
# Configure AWS CLI
aws configure set aws_access_key_id minioadmin
aws configure set aws_secret_access_key minioadmin123
aws configure set default.region us-east-1

# Create bucket
aws --endpoint-url http://localhost:9000 s3 mb s3://test-bucket

# Upload file
aws --endpoint-url http://localhost:9000 s3 cp testfile.txt s3://test-bucket/

# List objects
aws --endpoint-url http://localhost:9000 s3 ls s3://test-bucket/

# Download file
aws --endpoint-url http://localhost:9000 s3 cp s3://test-bucket/testfile.txt downloaded.txt
```

Or use the provided initialization script:

```bash
chmod +x data/setup.sh
./data/setup.sh
```

## Fess Configuration

### File Crawl Configuration

Configure Fess to crawl MinIO buckets using S3 protocol:

| Name | Value |
|:-----|:------|
| Name | MinIO Test |
| Path | s3://test-bucket/ |
| Parameter | endpoint=http://localhost:9000<br>region=us-east-1<br>accessKey=minioadmin<br>secretKey=minioadmin123 |

**Note**: S3 crawling may require:
1. AWS SDK for Java in Fess
2. Custom S3 file system implementation
3. Proper IAM credentials configuration

### Direct URL Access

For public buckets, files can be accessed via HTTP:

```
http://localhost:9000/test-bucket/file.txt
```

Configure as regular web crawl target in Fess.

## Object Storage Operations

### Using cURL

```bash
# List buckets (requires authentication)
curl -H "Host: localhost:9000" \
  --user minioadmin:minioadmin123 \
  http://localhost:9000/

# Upload file
curl -X PUT \
  --user minioadmin:minioadmin123 \
  --upload-file testfile.txt \
  http://localhost:9000/test-bucket/testfile.txt

# Download file
curl --user minioadmin:minioadmin123 \
  http://localhost:9000/test-bucket/testfile.txt

# Delete file
curl -X DELETE \
  --user minioadmin:minioadmin123 \
  http://localhost:9000/test-bucket/testfile.txt
```

### Using Python (boto3)

```python
import boto3
from botocore.client import Config

# Create S3 client
s3 = boto3.client('s3',
    endpoint_url='http://localhost:9000',
    aws_access_key_id='minioadmin',
    aws_secret_access_key='minioadmin123',
    config=Config(signature_version='s3v4'),
    region_name='us-east-1'
)

# Create bucket
s3.create_bucket(Bucket='test-bucket')

# Upload file
s3.upload_file('local_file.txt', 'test-bucket', 'remote_file.txt')

# List objects
response = s3.list_objects_v2(Bucket='test-bucket')
for obj in response.get('Contents', []):
    print(obj['Key'])

# Download file
s3.download_file('test-bucket', 'remote_file.txt', 'downloaded_file.txt')

# Delete file
s3.delete_object(Bucket='test-bucket', Key='remote_file.txt')
```

## MinIO Features

- **S3 Compatible**: Drop-in replacement for AWS S3
- **High Performance**: Designed for speed and scalability
- **Kubernetes Native**: Native support for container orchestration
- **Erasure Coding**: Data protection and availability
- **Object Versioning**: Keep multiple versions of objects
- **Object Locking**: WORM (Write-Once-Read-Many) compliance
- **Encryption**: Server-side and client-side encryption
- **IAM**: AWS IAM-compatible access management

## Configuration

- **API Port**: 9000 (S3-compatible API)
- **Console Port**: 9001 (Web UI)
- **Access Key**: minioadmin
- **Secret Key**: minioadmin123
- **Region**: us-east-1 (default)

## Bucket Policies

Set bucket policy for public access:

```bash
# Public read policy
cat > policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"AWS": ["*"]},
      "Action": ["s3:GetObject"],
      "Resource": ["arn:aws:s3:::test-bucket/*"]
    }
  ]
}
EOF

# Apply policy using mc
./mc anonymous set-json policy.json local/test-bucket
```

## Object Lifecycle

Configure lifecycle rules:

```bash
# Create lifecycle rule
cat > lifecycle.json <<EOF
{
  "Rules": [
    {
      "ID": "DeleteOldFiles",
      "Status": "Enabled",
      "Expiration": {
        "Days": 30
      }
    }
  ]
}
EOF

# Apply using AWS CLI
aws --endpoint-url http://localhost:9000 s3api put-bucket-lifecycle-configuration \
  --bucket test-bucket \
  --lifecycle-configuration file://lifecycle.json
```

## Monitoring

```bash
# Server info
curl http://localhost:9000/minio/health/live

# Get MinIO version
docker compose exec minio minio --version

# View logs
docker compose logs -f minio
```

## Stop MinIO

```bash
docker compose down
```

## Use Cases for Fess

1. **Document Storage**: Crawl PDF, Word, Excel files stored in S3
2. **Media Files**: Index images, videos with metadata
3. **Backup Archives**: Search through archived documents
4. **Multi-region**: Test distributed file access
5. **Large Files**: Handle files too large for file system crawl

## Performance Tuning

For better performance:

```yaml
environment:
  MINIO_ROOT_USER: minioadmin
  MINIO_ROOT_PASSWORD: minioadmin123
  MINIO_BROWSER_REDIRECT_URL: http://localhost:9001
```

## Integration Patterns

### Pattern 1: Direct HTTP Access

For public buckets, use standard web crawling:
- URL: http://localhost:9000/bucket-name/
- No authentication required for public buckets

### Pattern 2: S3 API Integration

Use AWS SDK with MinIO endpoint:
- Endpoint: http://localhost:9000
- Access patterns: listObjects, getObject

### Pattern 3: Event Notifications

MinIO can send events to webhooks, Kafka, etc. when objects change:
- Configure webhook to notify Fess
- Trigger incremental crawls on file changes

## Security Notes

- **Default Credentials**: Change for production
- **Encryption**: Enable SSL/TLS in production
- **Access Control**: Use IAM policies for fine-grained access
- **Network**: Restrict access to trusted networks

## Troubleshooting

### Connection refused

Wait for MinIO to fully start:

```bash
docker compose logs -f minio
# Wait for "API" and "Console" ready messages
```

### Access denied

Check credentials and bucket policies:

```bash
./mc admin info local
./mc admin policy list local
```

### Bucket not found

Create bucket first:

```bash
./mc mb local/test-bucket
```

## Notes

- **Port 9000**: S3 API endpoint
- **Port 9001**: Web console
- **Data Persistence**: Stored in Docker volume `minio_data`
- **S3 Compatible**: Works with AWS SDK and CLI tools
- **Default Region**: us-east-1

## Resources

- [MinIO Documentation](https://min.io/docs/minio/linux/index.html)
- [MinIO Client Guide](https://min.io/docs/minio/linux/reference/minio-mc.html)
- [S3 API Compatibility](https://min.io/docs/minio/linux/developers/s3-api-compatibility.html)
- [AWS SDK Configuration](https://min.io/docs/minio/linux/developers/aws-sdk.html)
