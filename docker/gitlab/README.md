GitLab CE Test Environment
===========================

## Overview

This environment provides GitLab Community Edition, a complete DevOps platform for testing Fess crawling of Git repositories, issues, wikis, and CI/CD content.

## ⚠️ Resource Requirements

GitLab is resource-intensive:
- **Minimum RAM**: 4GB (8GB recommended)
- **Disk Space**: 10GB+
- **Startup Time**: 3-5 minutes on first run
- **CPU**: 2+ cores recommended

Ensure Docker has sufficient resources allocated before starting.

## Run GitLab

```bash
docker compose up -d
```

**Wait 3-5 minutes** for GitLab to fully initialize on first startup.

## Access GitLab

- **URL**: http://localhost:8929
- **SSH**: localhost:2289
- **Initial root password**: `gitlabadmin123`

### First Login

1. Open http://localhost:8929
2. Wait for GitLab to finish initializing
3. Username: `root`
4. Password: `gitlabadmin123`
5. **Change password** on first login

## Check Startup Progress

```bash
# Watch logs
docker compose logs -f gitlab

# Check if GitLab is ready
docker compose exec gitlab gitlab-ctl status

# Wait for this message:
# "gitlab Reconfigured!"
```

## Create Test Data

### Create Project

1. Click "Create a project"
2. Select "Create blank project"
3. Fill in:
   - Project name: Test Project
   - Project slug: test-project
   - Visibility: Public (for easy crawling)
4. Initialize with README
5. Click "Create project"

### Add Files via Web IDE

1. Go to project → Repository
2. Click "Web IDE" or "+"
3. Create files:

**README.md:**
```markdown
# Test Project

This is a test project for GitLab and Fess integration.

## Features
- Issue tracking
- Wiki pages
- CI/CD pipelines
- Merge requests
```

**docs/guide.md:**
```markdown
# User Guide

## Installation
Instructions for installing the project.

## Usage
How to use the project.
```

4. Commit changes

### Create Issues

1. Go to project → Issues
2. Click "New issue"
3. Create sample issues:

**Issue 1:**
- Title: Bug in login form
- Description: Login form doesn't validate email properly
- Labels: bug, priority::high

**Issue 2:**
- Title: Add dark mode feature
- Description: Users requested a dark mode theme
- Labels: feature, enhancement

**Issue 3:**
- Title: Update documentation
- Description: API documentation needs to be updated
- Labels: documentation

### Create Wiki

1. Go to project → Wiki
2. Click "Create your first page"
3. Create pages:

**Home:**
```markdown
# Project Wiki

Welcome to the project wiki.

## Contents
- [Installation](installation)
- [Configuration](configuration)
- [API Reference](api)
```

**Installation:**
```markdown
# Installation Guide

## Prerequisites
- Git
- Docker

## Steps
1. Clone repository
2. Run docker compose up
3. Access http://localhost:8080
```

### Create Merge Request

1. Create new branch
2. Make changes
3. Push branch
4. Create merge request with description

## Fess Configuration

### Web Crawl Configuration

Configure Fess to crawl GitLab:

| Name | Value |
|:-----|:------|
| Name | GitLab Test |
| URL | http://localhost:8929/test-project |
| Depth | 4-5 |
| Max Access Count | 2000 |

**Crawl Targets:**
- Repository files
- Issues and discussions
- Merge requests
- Wiki pages
- Project pages
- User profiles

**Note**: Public projects are crawlable. For private projects, configure authentication.

### REST API Access

GitLab provides comprehensive REST API:

```bash
# Create personal access token first:
# User Settings → Access Tokens → Create token (api scope)

# Get projects
curl "http://localhost:8929/api/v4/projects"

# Get specific project
curl "http://localhost:8929/api/v4/projects/1"

# Get issues
curl "http://localhost:8929/api/v4/projects/1/issues"

# Get merge requests
curl "http://localhost:8929/api/v4/projects/1/merge_requests"

# Get wiki pages
curl "http://localhost:8929/api/v4/projects/1/wikis"

# Get repository tree
curl "http://localhost:8929/api/v4/projects/1/repository/tree"

# With authentication
curl --header "PRIVATE-TOKEN: your_access_token" \
  "http://localhost:8929/api/v4/projects"
```

### Generate Access Token

1. Click profile icon → Preferences
2. Go to "Access Tokens"
3. Create token:
   - Name: Fess Integration
   - Scopes: api, read_api, read_repository
4. Click "Create personal access token"
5. Copy token (shown only once)

## GitLab Features

- **Source Code Management**: Git repositories
- **Issue Tracking**: Bugs, features, tasks
- **Merge Requests**: Code review workflow
- **Wiki**: Documentation pages
- **CI/CD**: Pipelines and runners
- **Container Registry**: Docker images
- **Snippets**: Code snippets sharing
- **Milestones**: Release planning
- **Labels**: Categorization
- **Time Tracking**: Estimate and log time
- **Boards**: Kanban-style issue boards
- **Groups**: Organize projects
- **Web IDE**: Edit code in browser
- **Security Scanning**: SAST, DAST, dependency scanning

## Configuration

- **HTTP Port**: 8929
- **SSH Port**: 2289
- **Storage**: Docker volumes for config, logs, data
- **Database**: PostgreSQL (embedded)
- **Redis**: Included for caching
- **Memory**: Uses 2-4GB RAM

## User Management

### Create Users

1. Admin Area → Users
2. Click "New user"
3. Fill in details:
   - Name: Test User
   - Username: testuser
   - Email: test@example.com
4. Click "Create user"
5. Edit user → Set password

### Create Groups

1. Menu → Groups → Create group
2. Fill in:
   - Group name: Development Team
   - Group URL: dev-team
   - Visibility: Public
3. Add members with roles

### Roles

- **Guest**: View issues, wiki
- **Reporter**: Create issues, leave comments
- **Developer**: Push to non-protected branches, manage issues
- **Maintainer**: Push to protected branches, manage project
- **Owner**: Full access, delete project

## CI/CD Configuration

Create `.gitlab-ci.yml`:

```yaml
stages:
  - test
  - build

test_job:
  stage: test
  script:
    - echo "Running tests..."
    - npm test

build_job:
  stage: build
  script:
    - echo "Building application..."
    - npm run build
```

## Integration Examples

### Webhook Configuration

1. Project → Settings → Webhooks
2. Add webhook:
   - URL: http://your-fess-server/webhook
   - Trigger: Push events, Issues events, Wiki page events
3. Click "Add webhook"

### SSH Access

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add public key to GitLab
# Profile → SSH Keys → Paste public key

# Clone via SSH
git clone ssh://git@localhost:2289/root/test-project.git

# Push changes
git add .
git commit -m "Update"
git push origin main
```

## Use Cases for Fess

1. **Code Search**: Search across all repositories
2. **Issue Search**: Find issues and discussions
3. **Documentation Search**: Search wikis and markdown files
4. **Comment Search**: Find code review comments
5. **Cross-Project Search**: Search across multiple projects
6. **Historical Search**: Find old commits and discussions

## Integration Patterns

### Pattern 1: Web Crawling

Crawl GitLab as website:
- Follow project links
- Extract issues, MRs, wikis
- Index public content

### Pattern 2: REST API

Use GitLab API:
- List all projects
- Get issues, MRs, wikis
- Structured data access
- Incremental updates

### Pattern 3: Git Clone

Clone repositories:
```bash
git clone http://localhost:8929/root/test-project.git
# Index files with file system crawler
```

### Pattern 4: Webhooks

Real-time updates:
- Configure webhook
- Receive push/issue/MR events
- Trigger incremental crawls

## Administration

### GitLab Rails Console

```bash
docker compose exec gitlab gitlab-rails console

# Example commands:
> User.count
> Project.all
> Issue.where(state: 'opened').count
```

### Backup

```bash
# Create backup
docker compose exec gitlab gitlab-backup create

# Backup location
docker compose exec gitlab ls /var/opt/gitlab/backups/

# Copy backup
docker compose cp gitlab:/var/opt/gitlab/backups/backup_file.tar ./
```

### Restore

```bash
# Copy backup to container
docker compose cp backup_file.tar gitlab:/var/opt/gitlab/backups/

# Stop services
docker compose exec gitlab gitlab-ctl stop puma
docker compose exec gitlab gitlab-ctl stop sidekiq

# Restore
docker compose exec gitlab gitlab-backup restore BACKUP=timestamp

# Restart
docker compose restart gitlab
```

## Monitoring

```bash
# Check status
docker compose exec gitlab gitlab-ctl status

# View logs
docker compose exec gitlab gitlab-ctl tail

# Check resource usage
docker stats gitlab

# Check database
docker compose exec gitlab gitlab-psql -d gitlabhq_production -c "SELECT COUNT(*) FROM issues;"
```

## Stop GitLab

```bash
docker compose down
```

**Note**: Stopping and starting GitLab takes several minutes.

## Performance Tuning

For better performance, edit environment in `compose.yaml`:

```yaml
environment:
  GITLAB_OMNIBUS_CONFIG: |
    external_url 'http://localhost:8929'
    gitlab_rails['gitlab_shell_ssh_port'] = 2289
    # Performance tuning
    puma['worker_processes'] = 2
    sidekiq['max_concurrency'] = 10
    postgresql['shared_buffers'] = "256MB"
    prometheus_monitoring['enable'] = false
```

## Troubleshooting

### GitLab not starting

Check logs:
```bash
docker compose logs -f gitlab
```

Common issues:
- Insufficient memory
- Port conflicts
- Slow disk I/O

### 502 error

GitLab is still starting. Wait 3-5 minutes and refresh.

```bash
# Check services
docker compose exec gitlab gitlab-ctl status

# Wait for all services to be "running"
```

### Out of memory

Increase Docker memory:
- Docker Desktop → Settings → Resources → Memory → 8GB

Or reduce GitLab memory usage:
```yaml
environment:
  GITLAB_OMNIBUS_CONFIG: |
    puma['worker_processes'] = 1
    sidekiq['max_concurrency'] = 5
```

### Slow performance

- Increase allocated CPU cores
- Use SSD for Docker storage
- Disable unused features
- Consider using external PostgreSQL/Redis

## Security

1. **Change root password** immediately
2. **Disable registration** if not needed: Admin Area → Settings → Sign-up restrictions
3. **Enable 2FA**: User Settings → Account → Enable two-factor authentication
4. **Use HTTPS** in production (nginx reverse proxy)
5. **Regular backups**
6. **Keep updated**: `docker compose pull && docker compose up -d`
7. **Restrict API access** with personal access tokens
8. **Configure firewall** to restrict access

## Comparison: GitLab vs Gitea

| Feature | GitLab CE | Gitea |
|---------|-----------|-------|
| Memory | 4GB+ | 200MB |
| Startup | 3-5 min | 10-15s |
| Features | Comprehensive (CI/CD, Security, etc.) | Basic Git + Issues |
| Complexity | High | Low |
| Use Case | Enterprise, Full DevOps | Lightweight Git hosting |

Choose GitLab for: Full DevOps platform with CI/CD
Choose Gitea for: Lightweight Git hosting

## Notes

- **Port 8929**: Web interface (avoiding common ports)
- **Port 2289**: SSH for Git operations
- **Memory**: 2-4GB in use after startup
- **Disk**: Grows with repositories and artifacts
- **Startup**: 3-5 minutes on first run, 1-2 minutes on restart
- **Similar to**: GitHub Enterprise, Bitbucket

## Resources

- [GitLab Documentation](https://docs.gitlab.com/)
- [GitLab API](https://docs.gitlab.com/ee/api/)
- [GitLab CI/CD](https://docs.gitlab.com/ee/ci/)
- [GitLab Docker Images](https://docs.gitlab.com/ee/install/docker.html)
- [GitLab Runner](https://docs.gitlab.com/runner/)
