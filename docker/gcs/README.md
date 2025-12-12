Fake GCS Server Test Environment
=================================

## Overview

This environment provides fake-gcs-server, a Google Cloud Storage emulator for testing Fess file crawling capabilities with GCS.

## Run Fake GCS Server

```bash
docker compose up -d
```

Wait for the server to start (takes a few seconds).

## Access

- **API Endpoint**: http://localhost:4443
- **Storage URL**: http://localhost:4443/storage/v1/b

## Pre-loaded Test Data

Test data is automatically loaded from `./data` directory:
- `test-bucket/sample.txt` - Sample text file

Directory structure:
```
data/
  test-bucket/      <- Bucket name
    sample.txt      <- Object
```

## Initialize Additional Test Data

### Using cURL

```bash
# Upload file
curl -X POST \
  "http://localhost:4443/upload/storage/v1/b/test-bucket/o?uploadType=media&name=newfile.txt" \
  -H "Content-Type: text/plain" \
  -d "Hello, GCS!"

# List objects in bucket
curl "http://localhost:4443/storage/v1/b/test-bucket/o"

# Download file
curl "http://localhost:4443/storage/v1/b/test-bucket/o/sample.txt?alt=media"

# Delete file
curl -X DELETE "http://localhost:4443/storage/v1/b/test-bucket/o/sample.txt"
```

### Using Python (google-cloud-storage)

```python
from google.cloud import storage

# Create client with fake endpoint
client = storage.Client(
    project="test-project",
    _http=None,
)
client._http.base_url = "http://localhost:4443"

# Or use environment variable
import os
os.environ["STORAGE_EMULATOR_HOST"] = "http://localhost:4443"
client = storage.Client(project="test-project")

# Create bucket
bucket = client.create_bucket("my-bucket")

# Upload file
blob = bucket.blob("path/to/file.txt")
blob.upload_from_string("Hello, GCS!")

# Download file
content = blob.download_as_string()

# List objects
for blob in bucket.list_blobs():
    print(blob.name)
```

### Using gsutil

```bash
# Set emulator endpoint
export STORAGE_EMULATOR_HOST=http://localhost:4443

# List buckets
gsutil ls

# Copy file to bucket
gsutil cp localfile.txt gs://test-bucket/

# List objects
gsutil ls gs://test-bucket/

# Download file
gsutil cp gs://test-bucket/sample.txt ./downloaded.txt
```

## Fess Configuration

Configure Fess to crawl GCS buckets:

| Name | Value |
|:-----|:------|
| Name | GCS Test |
| Path | gs://test-bucket/ |
| Parameter | endpoint=http://localhost:4443 |

## Creating New Buckets

Add a new directory under `data/`:

```bash
mkdir -p data/new-bucket
echo "test content" > data/new-bucket/file.txt
docker compose restart
```

## API Endpoints

- `GET /storage/v1/b` - List buckets
- `GET /storage/v1/b/{bucket}/o` - List objects in bucket
- `GET /storage/v1/b/{bucket}/o/{object}?alt=media` - Download object
- `POST /upload/storage/v1/b/{bucket}/o?uploadType=media&name={name}` - Upload object
- `DELETE /storage/v1/b/{bucket}/o/{object}` - Delete object

## Configuration Options

The fake-gcs-server supports various options:

```bash
# HTTPS mode (default)
docker run -p 4443:4443 fsouza/fake-gcs-server

# HTTP mode
docker run -p 4443:4443 fsouza/fake-gcs-server -scheme http

# Both HTTP and HTTPS
docker run -p 4443:4443 -p 8000:8000 fsouza/fake-gcs-server -scheme both

# Custom port
docker run -p 8080:8080 fsouza/fake-gcs-server -port 8080

# View all options
docker run --rm fsouza/fake-gcs-server -help
```

## Stop Server

```bash
docker compose down
```

## Troubleshooting

### Connection refused

Wait for the server to start:

```bash
docker compose logs -f fake-gcs-server
```

### Bucket not found

Ensure the bucket directory exists under `data/`:

```bash
ls -la data/
mkdir -p data/your-bucket
```

### Object not loading

Check file permissions:

```bash
chmod -R 755 data/
```

## Notes

- **Port**: 4443 (HTTP)
- **Data Location**: `./data` directory
- **Bucket Creation**: Create directories under `data/`
- **Object Storage**: Place files in bucket directories

## Resources

- [fake-gcs-server GitHub](https://github.com/fsouza/fake-gcs-server)
- [Google Cloud Storage Documentation](https://cloud.google.com/storage/docs)
- [gsutil Documentation](https://cloud.google.com/storage/docs/gsutil)
