WebDAV Test Environment
========================

## Overview

This environment provides a WebDAV server for testing Fess WebDAV crawling capabilities.

## Prepare Test Data

Before starting the server, prepare test files:

```bash
mkdir -p data/webdav
# Copy your test files to data/webdav/
echo "Test WebDAV content" > data/webdav/test.txt
```

## Start WebDAV Server

```bash
docker compose up -d
```

## Stop WebDAV Server

```bash
docker compose down
```

## WebDAV Server Information

- **URL**: http://localhost:10080/
- **Username**: testuser
- **Password**: testpass
- **Authentication**: Basic Auth

## Fess Configuration

### File Crawl Configuration

1. Download [Fess](https://github.com/codelibs/fess/releases)

2. Configure File Crawl Configuration:

   | Name | Value |
   |:-----|:------|
   | Name | WebDAV Test |
   | Path | http://localhost:10080/ |

3. Configure File Authentication:

   | Field | Value |
   |:-----:|:------|
   | Protocol Scheme | http |
   | Hostname | localhost |
   | Port | 10080 |
   | Authentication Type | BASIC |
   | Username | testuser |
   | Password | testpass |

4. Start Crawl

## Manual WebDAV Access

### Using curl

```bash
# List directory contents
curl -u testuser:testpass 'http://localhost:10080/' -X PROPFIND --data '<?xml version="1.0"?><propfind xmlns="DAV:"><prop><displayname/></prop></propfind>'

# Upload a file
curl -u testuser:testpass -T test.txt http://localhost:10080/test.txt

# Download a file
curl -u testuser:testpass http://localhost:10080/test.txt

# Delete a file
curl -u testuser:testpass -X DELETE http://localhost:10080/test.txt
```

### Using cadaver (WebDAV command-line client)

```bash
# Install cadaver
# Ubuntu/Debian: apt-get install cadaver
# macOS: brew install cadaver

# Connect to WebDAV server
cadaver http://localhost:10080/
# Username: testuser
# Password: testpass

# WebDAV commands
dav:/> ls
dav:/> put localfile.txt
dav:/> get remotefile.txt
dav:/> delete file.txt
dav:/> quit
```

### Linux/macOS Mount

```bash
# Create mount point
mkdir -p ~/webdav

# Mount WebDAV share (Ubuntu/Debian)
sudo mount -t davfs http://localhost:10080 ~/webdav
# Username: testuser
# Password: testpass

# Unmount
sudo umount ~/webdav
```

### Windows Mount

```powershell
# Map network drive
net use W: http://localhost:10080 /user:testuser testpass

# Disconnect
net use W: /delete
```

## Upload Test Files

Create sample test files:

```bash
# Create test directory structure
mkdir -p data/webdav/documents
mkdir -p data/webdav/images

# Create sample text files
echo "Sample document 1" > data/webdav/documents/sample1.txt
echo "Sample document 2" > data/webdav/documents/sample2.txt
echo "サンプルドキュメント" > data/webdav/documents/japanese.txt

# Create sample HTML file
cat > data/webdav/documents/sample.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>WebDAV Test Page</title></head>
<body>
<h1>WebDAV Test Content</h1>
<p>This is a test HTML file for WebDAV crawling.</p>
</body>
</html>
EOF
```

## Notes

- The WebDAV server requires Basic Authentication
- All files in `data/webdav/` directory are accessible via WebDAV
- Supports standard WebDAV operations: GET, PUT, DELETE, PROPFIND, MKCOL, etc.
- Compatible with WebDAV clients on Windows, macOS, and Linux
