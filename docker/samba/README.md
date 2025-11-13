Samba/SMB Test Environment
===========================

## Overview

This environment provides a Samba server for testing Fess SMB/CIFS crawling capabilities.

## Prepare Test Data

Before starting the server, prepare test data:

```bash
mkdir -p data/share data/users
# Copy your test files to data/share/ and data/users/
```

## Start Samba Server

```bash
docker compose up -d
```

## Stop Samba Server

```bash
docker compose down
```

## Samba Server Information

- **Host**: localhost
- **SMB Port**: 1139
- **CIFS Port**: 1445

### Shares

| Share Name | Path | Access |
|:-----------|:-----|:-------|
| public | /share/share | Guest access allowed |
| users | /share/users | testuser1, testuser2 |

### User Accounts

| Username | Password |
|:--------:|:--------:|
| testuser1 | test123 |
| testuser2 | test123 |

## Fess Configuration

### File Crawl Configuration

1. Download [Fess](https://github.com/codelibs/fess/releases)

2. Configure File Crawl Configuration with one of the following:

   **For public share (no authentication):**
   - Path: `smb://localhost:1139/public/`

   **For authenticated access:**
   - Path: `smb://localhost:1139/users/`
   - Username: testuser1 (or testuser2)
   - Password: test123

3. For SMB1 protocol support:
   - Use `smb1://` protocol prefix instead of `smb://`

4. Start Crawl

## Manual SMB Access

### Linux/macOS

```bash
# Install smbclient if not available
# Ubuntu/Debian: apt-get install smbclient
# macOS: brew install samba

# List shares
smbclient -L //localhost -p 1139 -U testuser1

# Connect to share
smbclient //localhost/users -p 1139 -U testuser1
# Password: test123
```

### Windows

```powershell
# Map network drive
net use Z: \\localhost@1139\users /user:testuser1 test123
```

## Notes

- The server runs on non-standard ports (1139 for NetBIOS, 1445 for CIFS) to avoid conflicts
- Both SMB2/3 and SMB1 protocols are supported
- The public share allows anonymous access for testing
- Test files should be placed in the `data/share/` and `data/users/` directories before starting
