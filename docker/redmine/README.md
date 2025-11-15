Redmine Test Environment
=========================

## Overview

This environment provides Redmine, a flexible open-source project management and issue tracking web application, for testing Fess crawling of project management content.

## Run Redmine

```bash
docker compose up -d
```

Wait for Redmine to initialize (takes 30-60 seconds on first run).

## Access Redmine

- **URL**: http://localhost:3001
- **Default Admin Account**:
  - Username: `admin`
  - Password: `admin`

**IMPORTANT**: Change the admin password immediately after first login!

## Initial Setup

1. Open http://localhost:3001
2. Click "Sign in" (top right)
3. Login with admin/admin
4. Click "My account" → Change password
5. Go to "Administration" → "Settings" to configure

## Create Test Data

### Create Project

1. Click "Projects" → "New project"
2. Fill in:
   - Name: Test Project
   - Identifier: test-project
   - Description: Test project for Fess crawling
3. Enable modules: Issues, Wiki, Documents, Files
4. Click "Create"

### Create Issues

1. Go to project → "Issues" → "New issue"
2. Create sample issues:

**Issue 1:**
- Tracker: Bug
- Subject: Sample bug report
- Description: This is a sample bug for testing Redmine crawling
- Status: New
- Priority: Normal

**Issue 2:**
- Tracker: Feature
- Subject: New feature request
- Description: This is a sample feature request
- Status: In Progress
- Priority: High

**Issue 3:**
- Tracker: Support
- Subject: Support question
- Description: Sample support question for testing
- Status: Resolved

### Create Wiki Pages

1. Go to project → "Wiki"
2. Create pages:

**Home Page:**
```
# Project Documentation

This is the main documentation page for the test project.

## Overview
This project is for testing Redmine crawling capabilities.

## Features
* Issue tracking
* Wiki documentation
* Time tracking
* Gantt charts
```

**Installation Guide:**
```
# Installation Guide

## Requirements
- Ruby 2.7+
- PostgreSQL or MySQL

## Steps
1. Install dependencies
2. Configure database
3. Run migrations
```

### Upload Documents

1. Go to project → "Documents" → "New document"
2. Add:
   - Title: Project Specification
   - Description: Technical specification document
   - Upload files (optional)

## Fess Configuration

### Web Crawl Configuration

Configure Fess to crawl Redmine:

| Name | Value |
|:-----|:------|
| Name | Redmine Test |
| URL | http://localhost:3001/ |
| Depth | 4-5 |
| Max Access Count | 2000 |
| Included URLs | http://localhost:3001/projects/.* |

**Crawl Targets:**
- Project pages
- Issues (bugs, features, support)
- Wiki pages
- Documents
- News
- Forums (if enabled)

**Note**: Public projects are crawlable without authentication. For private projects, configure web authentication in Fess.

### REST API Access

Redmine provides REST API for programmatic access:

```bash
# Get issues (requires API key)
curl http://localhost:3001/issues.json

# Get specific issue
curl http://localhost:3001/issues/1.json

# Get projects
curl http://localhost:3001/projects.json

# Get wiki pages
curl http://localhost:3001/projects/test-project/wiki/index.json

# With API authentication
curl -H "X-Redmine-API-Key: YOUR_API_KEY" http://localhost:3001/issues.json
```

### Generate API Key

1. Login to Redmine
2. Go to "My account" → "API access key"
3. Click "Show" or "Reset"
4. Use this key for API requests

## Redmine Features

- **Project Management**: Multiple projects, subprojects
- **Issue Tracking**: Bugs, features, support tickets
- **Wiki**: Project documentation
- **Time Tracking**: Log time on issues
- **Gantt Chart**: Visual project timeline
- **Calendar**: Issue deadlines
- **News**: Project announcements
- **Forums**: Discussions
- **Documents**: File repository
- **Custom Fields**: Extensible data model
- **Role-Based Access**: Fine-grained permissions
- **Email Notifications**: Automated updates
- **SCM Integration**: Git, SVN, Mercurial

## Configuration

- **HTTP Port**: 3001
- **Database**: PostgreSQL 15
- **Files Storage**: Docker volume
- **Plugins**: Mounted volume for extensions

## User Management

### Create Users

1. Go to "Administration" → "Users"
2. Click "New user"
3. Fill in details:
   - Login: testuser
   - First name: Test
   - Last name: User
   - Email: test@example.com
   - Password: testpass123
4. Click "Create"

### Assign Roles

1. Go to project → "Settings" → "Members"
2. Click "New member"
3. Select user and role (Manager, Developer, Reporter)
4. Click "Add"

## Project Configuration

### Enable Modules

1. Go to project → "Settings" → "Modules"
2. Enable/disable:
   - Issue tracking ✓
   - Time tracking ✓
   - News ✓
   - Documents ✓
   - Files ✓
   - Wiki ✓
   - Repository
   - Forums ✓
   - Calendar ✓
   - Gantt chart ✓

### Trackers

Default trackers:
- Bug: For defects
- Feature: For new functionality
- Support: For questions

Add custom trackers in Administration → Trackers.

### Issue Statuses

Default statuses:
- New
- In Progress
- Resolved
- Feedback
- Closed
- Rejected

### Workflows

Configure state transitions:
1. Administration → Workflow
2. Select tracker and role
3. Define allowed transitions

## Plugins

Install plugins:

```bash
# Download plugin to plugins directory
cd /path/to/redmine/plugins
git clone https://github.com/plugin-author/plugin-name.git

# Install dependencies
docker compose exec redmine bundle install

# Migrate database
docker compose exec redmine bundle exec rake redmine:plugins:migrate

# Restart
docker compose restart redmine
```

Popular plugins:
- Agile Board
- Checklist
- CKEditor
- Dashboard
- Slack integration

## Backup

```bash
# Backup database
docker compose exec redmine-db pg_dump -U redmine redmine > redmine_backup.sql

# Backup files
docker run --rm -v redmine_files:/data -v $(pwd):/backup alpine tar czf /backup/redmine-files.tar.gz /data
```

## Restore

```bash
# Restore database
docker compose exec -T redmine-db psql -U redmine redmine < redmine_backup.sql

# Restore files
docker run --rm -v redmine_files:/data -v $(pwd):/backup alpine tar xzf /backup/redmine-files.tar.gz -C /
```

## Use Cases for Fess

1. **Issue Search**: Search across all issues and comments
2. **Wiki Search**: Full-text search of documentation
3. **Cross-Project Search**: Search content across multiple projects
4. **Historical Search**: Find old issues and discussions
5. **Knowledge Base**: Index resolved issues as knowledge base

## Integration Patterns

### Pattern 1: Web Crawling

Crawl Redmine as a website:
- Follow project, issue, and wiki links
- Extract titles, descriptions, comments
- Index public content

### Pattern 2: REST API

Use Redmine API:
- List all issues with filters
- Get wiki pages content
- Access structured data
- Incremental updates

### Pattern 3: Database Access

Direct database crawling:
- Connect to PostgreSQL database
- Query issues, wiki_contents tables
- Most complete data access

### Pattern 4: RSS/Atom Feeds

Subscribe to activity feeds:
```
http://localhost:3001/projects/test-project/activity.atom
http://localhost:3001/issues.atom
```

## Administration

### Email Configuration

Configure email in `compose.yaml`:

```yaml
environment:
  REDMINE_DB_POSTGRES: redmine-db
  REDMINE_DB_DATABASE: redmine
  REDMINE_DB_USERNAME: redmine
  REDMINE_DB_PASSWORD: redmine
  # Email settings
  REDMINE_EMAIL_DELIVERY_METHOD: smtp
  REDMINE_SMTP_ADDRESS: smtp.example.com
  REDMINE_SMTP_PORT: 587
  REDMINE_SMTP_USERNAME: user@example.com
  REDMINE_SMTP_PASSWORD: password
```

### LDAP Authentication

1. Administration → LDAP authentication
2. Click "New authentication mode"
3. Configure LDAP server:
   - Name: Company LDAP
   - Host: ldap.example.com
   - Port: 389
   - Base DN: dc=example,dc=com
   - Login attribute: uid

## Monitoring

```bash
# Check application logs
docker compose logs -f redmine

# Check database
docker compose exec redmine-db psql -U redmine -d redmine -c "SELECT COUNT(*) FROM issues;"

# Check storage
docker compose exec redmine du -sh /usr/src/redmine/files
```

## Stop Redmine

```bash
docker compose down
```

## Performance Tuning

For better performance:

```yaml
environment:
  RAILS_ENV: production
  RAILS_MAX_THREADS: 5
  WEB_CONCURRENCY: 2
```

Consider using Puma or Unicorn for production.

## Troubleshooting

### "Page not found" error

Wait for initialization to complete:

```bash
docker compose logs -f redmine
# Wait for "Listening on http://0.0.0.0:3000"
```

### Database connection error

Check database container:

```bash
docker compose ps
docker compose logs redmine-db
```

### Cannot upload files

Check permissions:

```bash
docker compose exec redmine ls -la /usr/src/redmine/files
```

### Slow performance

- Increase memory allocation
- Add database indexes
- Enable caching
- Use reverse proxy (nginx)

## Security

1. **Change admin password** immediately
2. **Use strong passwords** for all accounts
3. **Enable HTTPS** in production (use reverse proxy)
4. **Regular backups** of database and files
5. **Keep updated**: `docker compose pull && docker compose up -d`
6. **Restrict API access** with API keys
7. **Configure permissions** properly per project

## Notes

- **Port 3001**: Web interface (avoiding conflict with Gitea)
- **Database**: PostgreSQL 15
- **Ruby**: Latest version in official image
- **Data Persistence**: Database, files, and plugins in volumes
- **Memory**: Requires ~500MB RAM
- **Startup Time**: 30-60 seconds
- **Similar to**: Jira, GitHub Issues, GitLab Issues

## Resources

- [Redmine Official Website](https://www.redmine.org/)
- [Redmine Guide](https://www.redmine.org/guide)
- [REST API Documentation](https://www.redmine.org/projects/redmine/wiki/Rest_api)
- [Plugin Directory](https://www.redmine.org/plugins)
- [Themes Directory](https://www.redmine.org/projects/redmine/wiki/Theme_List)
