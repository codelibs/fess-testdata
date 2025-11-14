Gitea Test Environment
======================

## Overview

This environment provides Gitea, a lightweight self-hosted Git service for testing Fess code repository and documentation crawling capabilities.

## Run Gitea

```bash
docker compose up -d
```

Wait for Gitea to initialize (takes 10-15 seconds on first run).

## Access Gitea

- **Web UI**: http://localhost:3000
- **SSH**: localhost:2222

On first access, you'll need to complete the initial setup:
1. Open http://localhost:3000
2. Most settings are pre-configured
3. Create an admin account
4. Click "Install Gitea"

## Create Test Repository

### Via Web UI

1. Login to Gitea
2. Click "+" → "New Repository"
3. Repository name: "test-repo"
4. Add README
5. Create repository
6. Add files via web editor

### Via Git Command Line

```bash
# Create local repository
mkdir test-repo
cd test-repo
git init

# Add some files
echo "# Test Repository" > README.md
echo "This is a test repository for Fess crawling" >> README.md

cat > document.md <<EOF
# Documentation

This is a sample documentation file.

## Features

- Git repository hosting
- Issue tracking
- Pull requests
- Wiki pages
EOF

echo "console.log('Hello World');" > script.js

# Commit files
git add .
git commit -m "Initial commit"

# Push to Gitea
git remote add origin http://localhost:3000/username/test-repo.git
git push -u origin master
```

Or use the provided initialization script:

```bash
chmod +x data/setup.sh
./data/setup.sh
```

## Fess Configuration

### Web Crawl Configuration

Configure Fess to crawl Gitea repositories:

| Name | Value |
|:-----|:------|
| Name | Gitea Test |
| URL | http://localhost:3000/username/test-repo |
| Depth | 3-5 |
| Max Access Count | 1000 |

**Crawl Targets:**
- Repository files (code, documentation)
- README files
- Wiki pages
- Issue discussions
- Pull request descriptions

### API Access

Gitea provides REST API for programmatic access:

```bash
# Get repository info
curl http://localhost:3000/api/v1/repos/username/test-repo

# List repository files
curl http://localhost:3000/api/v1/repos/username/test-repo/contents

# Search repositories
curl http://localhost:3000/api/v1/repos/search?q=test
```

### Raw File Access

Access files directly via HTTP:

```
http://localhost:3000/username/test-repo/raw/branch/master/README.md
http://localhost:3000/username/test-repo/raw/branch/master/docs/guide.md
```

## Gitea Features

- **Git Hosting**: Full Git repository management
- **Web Interface**: Browse code, commits, branches
- **Issue Tracker**: Bug tracking and project management
- **Pull Requests**: Code review workflow
- **Wiki**: Documentation pages
- **Organizations**: Group repositories
- **Webhooks**: Integration with external services
- **API**: RESTful API for automation

## Configuration

- **HTTP Port**: 3000
- **SSH Port**: 2222
- **Database**: SQLite3 (embedded)
- **Data Storage**: Docker volume `gitea_data`

## API Examples

### Authentication

```bash
# Generate access token in Gitea UI:
# Settings → Applications → Generate New Token

TOKEN="your_access_token"

# Use token in API requests
curl -H "Authorization: token $TOKEN" \
  http://localhost:3000/api/v1/user/repos
```

### Repository Operations

```bash
# Create repository via API
curl -X POST "http://localhost:3000/api/v1/user/repos" \
  -H "Authorization: token $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "api-test-repo",
    "description": "Created via API",
    "private": false
  }'

# List user repositories
curl -H "Authorization: token $TOKEN" \
  http://localhost:3000/api/v1/user/repos

# Get repository contents
curl http://localhost:3000/api/v1/repos/username/test-repo/contents

# Get file content
curl http://localhost:3000/api/v1/repos/username/test-repo/contents/README.md

# Search code
curl "http://localhost:3000/api/v1/repos/username/test-repo/search?q=function"
```

### Issue Operations

```bash
# Create issue
curl -X POST "http://localhost:3000/api/v1/repos/username/test-repo/issues" \
  -H "Authorization: token $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Test Issue",
    "body": "This is a test issue for Fess crawling"
  }'

# List issues
curl http://localhost:3000/api/v1/repos/username/test-repo/issues
```

## Wiki Pages

Enable and create wiki pages:

1. Go to repository settings
2. Enable "Wiki" feature
3. Create wiki pages via web UI or git

Wiki pages can be crawled as documentation:
```
http://localhost:3000/username/test-repo/wiki
http://localhost:3000/username/test-repo/wiki/Home
```

## Use Cases for Fess

1. **Code Search**: Index source code across repositories
2. **Documentation**: Search README, wiki, and markdown files
3. **Issue Tracker**: Search issue discussions and solutions
4. **Collaboration**: Find pull request discussions and reviews
5. **Knowledge Base**: Index technical documentation

## Integration Patterns

### Pattern 1: Web Crawling

Crawl Gitea as a regular website:
- Start URL: http://localhost:3000/
- Follow links to repositories, issues, wikis
- Extract code and documentation content

### Pattern 2: API Integration

Use Gitea API for structured data access:
- List all repositories
- Get file contents via API
- Index metadata (author, date, language)

### Pattern 3: Git Clone

Clone repositories and index locally:
```bash
git clone http://localhost:3000/username/test-repo.git
# Index cloned files with file system crawler
```

## Administration

### User Management

```bash
# Create user via CLI
docker compose exec gitea gitea admin user create \
  --username testuser \
  --password testpass123 \
  --email test@example.com

# List users
docker compose exec gitea gitea admin user list

# Change password
docker compose exec gitea gitea admin user change-password \
  --username testuser --password newpass123
```

### Repository Management

```bash
# List repositories
docker compose exec gitea gitea admin repo-sync-releases

# Repository statistics
curl http://localhost:3000/api/v1/admin/stats
```

## Monitoring

```bash
# Check application status
curl http://localhost:3000/api/healthz

# View logs
docker compose logs -f gitea

# Database location (SQLite)
docker compose exec gitea ls -l /data/gitea/
```

## Stop Gitea

```bash
docker compose down
```

## Backup

```bash
# Backup Gitea data
docker compose exec gitea gitea dump -c /data/gitea/conf/app.ini

# Backup volume
docker run --rm -v gitea_data:/data -v $(pwd):/backup \
  alpine tar czf /backup/gitea-backup.tar.gz /data
```

## Performance Tuning

For better performance with many repositories:

```yaml
environment:
  - GITEA__database__DB_TYPE=postgres  # Use PostgreSQL instead of SQLite
  - GITEA__cache__ENABLED=true
  - GITEA__indexer__REPO_INDEXER_ENABLED=true
```

## Security Notes

- Change default admin password immediately
- Use SSH keys for git operations
- Enable 2FA for admin accounts
- Configure HTTPS in production
- Set up backup automation

## Troubleshooting

### Cannot access web UI

Wait for Gitea to fully initialize:

```bash
docker compose logs -f gitea
# Wait for "Starting new Web server" message
```

### Git push fails

Check SSH port and credentials:

```bash
# Test SSH connection
ssh -p 2222 git@localhost

# Use HTTP instead
git remote set-url origin http://localhost:3000/username/test-repo.git
```

### Permission denied

Check data volume permissions:

```bash
docker compose exec gitea ls -la /data/
```

## Notes

- **Port 3000**: Web interface
- **Port 2222**: SSH (Git operations)
- **Database**: SQLite3 (suitable for testing, use PostgreSQL for production)
- **Data Persistence**: All data stored in Docker volume `gitea_data`
- **Memory**: Lightweight, requires ~200MB RAM
- **Similar to**: GitHub, GitLab, Bitbucket

## Resources

- [Gitea Documentation](https://docs.gitea.io/)
- [API Documentation](https://docs.gitea.io/en-us/api-usage/)
- [Configuration Cheat Sheet](https://docs.gitea.io/en-us/config-cheat-sheet/)
- [Webhooks](https://docs.gitea.io/en-us/webhooks/)
