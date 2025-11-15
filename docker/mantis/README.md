MantisBT Test Environment
==========================

## Overview

This environment provides MantisBT (Mantis Bug Tracker), a lightweight open-source bug tracking system, for testing Fess crawling of bug tracking and issue management content.

## Run MantisBT

```bash
docker compose up -d
```

Wait for MantisBT to initialize (takes 20-30 seconds on first run).

## Access MantisBT

- **URL**: http://localhost:8989
- **Initial Setup Required**: Yes (on first access)

## Initial Setup

1. Open http://localhost:8989
2. Complete installation wizard:

### Installation Steps

**Step 1: Pre-Installation Check**
- Click "Continue"

**Step 2: Installation Options**
- Type of Database: MySQL/MySQLi
- Hostname: mantis-db
- Username: mantis
- Password: mantis
- Database name: bugtracker
- Admin Username: administrator
- Admin Password: (set your password, e.g., admin123)
- Email: admin@example.com
- Click "Install/Upgrade Database"

**Step 3: Post Installation**
- Click "Continue"
- Remove admin directory message (can be ignored in Docker)

3. Login with administrator and your password

## Create Test Data

### Create Project

1. Go to "Manage" → "Manage Projects"
2. Click "Create New Project"
3. Fill in:
   - Project Name: Test Project
   - Status: release
   - View Status: public
   - Description: Test project for MantisBT and Fess integration
4. Click "Add Project"

### Create Categories

1. In project, go to "Categories"
2. Add categories:
   - Frontend
   - Backend
   - Database
   - Documentation

### Create Issues

1. Click "Report Issue"
2. Select project: Test Project
3. Create sample issues:

**Issue 1:**
- Category: Backend
- Reproducibility: always
- Severity: major
- Priority: high
- Summary: Login function fails with special characters
- Description: When using special characters in password, login fails with error
- Steps to Reproduce:
  1. Go to login page
  2. Enter username and password with special chars
  3. Click login
- Additional Information: Error occurs in auth.php line 42

**Issue 2:**
- Category: Frontend
- Severity: minor
- Priority: normal
- Summary: Button alignment issue on mobile
- Description: Submit button is not properly aligned on mobile devices

**Issue 3:**
- Category: Documentation
- Severity: feature
- Priority: low
- Summary: Need API documentation
- Description: Create comprehensive API documentation for developers

### Add Notes and Attachments

1. View an issue
2. Click "Add Note"
3. Add comments and discussions
4. Attach files (screenshots, logs, etc.)

## Fess Configuration

### Web Crawl Configuration

Configure Fess to crawl MantisBT:

| Name | Value |
|:-----|:------|
| Name | MantisBT Test |
| URL | http://localhost:8989/ |
| Depth | 3-4 |
| Max Access Count | 1000 |

**Crawl Targets:**
- Issue listings
- Issue details
- Project pages
- Roadmap
- Changelog
- Summary pages

**Note**: Public projects and issues are crawlable. For private content, configure authentication.

### REST API Access

MantisBT provides REST API (requires API token):

```bash
# Get API token:
# My Account → API Tokens → Create API Token

# Get all issues
curl http://localhost:8989/api/rest/issues \
  -H "Authorization: YOUR_API_TOKEN"

# Get specific issue
curl http://localhost:8989/api/rest/issues/1 \
  -H "Authorization: YOUR_API_TOKEN"

# Get projects
curl http://localhost:8989/api/rest/projects \
  -H "Authorization: YOUR_API_TOKEN"

# Create issue
curl -X POST http://localhost:8989/api/rest/issues \
  -H "Authorization: YOUR_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "summary": "Test issue",
    "description": "Created via API",
    "project": {"name": "Test Project"},
    "category": {"name": "Backend"}
  }'
```

### Generate API Token

1. Login to MantisBT
2. Click username → "My Account"
3. Go to "API Tokens" tab
4. Enter token name: "Fess Integration"
5. Click "Create API Token"
6. Copy the generated token

## MantisBT Features

- **Issue Tracking**: Bugs, features, tasks
- **Projects**: Multiple project support
- **Workflow**: Customizable issue lifecycle
- **Categories**: Organize issues
- **Versions**: Track releases
- **Roadmap**: Feature planning
- **Changelog**: Release notes
- **Time Tracking**: Log time spent
- **Custom Fields**: Extensible data model
- **Email Notifications**: Automated alerts
- **Filters**: Save search criteria
- **Tags**: Flexible categorization
- **Relationships**: Link related issues
- **Attachments**: File uploads
- **Notes**: Comments and discussions

## Configuration

- **HTTP Port**: 8989
- **Database**: MySQL 8.0
- **Language**: PHP
- **Memory**: ~200MB RAM
- **Lightweight**: Fast and simple

## User Management

### Create Users

1. Go to "Manage" → "Manage Users"
2. Click "Create New Account"
3. Fill in:
   - Username: testuser
   - Real name: Test User
   - Email: test@example.com
   - Access level: developer
   - Protected: unchecked
4. Click "Create User"

### Access Levels

- **viewer**: View issues only
- **reporter**: Report issues
- **updater**: Update issues
- **developer**: Full access to issues
- **manager**: Manage project
- **administrator**: System administration

### Assign Users to Projects

1. Go to project → "Manage" → "Manage Project"
2. Click project name
3. Go to "Manage User Access"
4. Add users with access levels

## Project Configuration

### Custom Fields

1. "Manage" → "Manage Custom Fields"
2. Click "Create Custom Field"
3. Add field:
   - Name: Affected Version
   - Type: List
   - Values: v1.0|v2.0|v3.0

### Workflow States

Default statuses:
- new
- feedback
- acknowledged
- confirmed
- assigned
- resolved
- closed

Customize in: "Manage" → "Manage Configuration" → "Workflow Thresholds"

### Categories

1. Project → "Manage Project"
2. Go to "Categories"
3. Add/edit categories

### Versions

1. Project → "Manage Project"
2. Go to "Versions"
3. Add version:
   - Version: 1.0.0
   - Description: First release
   - Released: yes/no
   - Date Order: release date

## Filtering and Search

### Create Filter

1. Click "View Issues"
2. Apply filters (project, status, category, etc.)
3. Click "Apply Filter"
4. Click "Save" to save filter

### Saved Filters

Access saved filters from "View Issues" dropdown.

## Reporting

### Summary Page

View at: http://localhost:8989/summary_page.php

Shows:
- Issues by status
- Issues by severity
- Issues by category
- Reporter effectiveness
- Developer stats

### Roadmap

View at: http://localhost:8989/roadmap_page.php

Shows planned features by version.

### Changelog

View at: http://localhost:8989/changelog_page.php

Shows resolved issues by version.

## Use Cases for Fess

1. **Bug Search**: Search across all bug reports
2. **Solution Search**: Find resolved issues and solutions
3. **Knowledge Base**: Index closed issues as KB
4. **Comment Search**: Find discussions in issue notes
5. **Cross-Project Search**: Search bugs across projects

## Integration Patterns

### Pattern 1: Web Crawling

Crawl MantisBT as website:
- Follow issue links
- Extract summaries, descriptions
- Index public issues

### Pattern 2: REST API

Use MantisBT API:
- List all issues
- Get detailed information
- Structured data access
- Incremental updates

### Pattern 3: RSS Feeds

Subscribe to issue feeds:
```
http://localhost:8989/issues_rss.php?project_id=1
```

### Pattern 4: Database Access

Direct database crawling:
- Connect to MySQL database
- Query mantis_bug_text_table
- Most complete access

## Backup

```bash
# Backup database
docker compose exec mantis-db mysqldump -u mantis -pmantis bugtracker > mantis_backup.sql

# Backup files
docker run --rm -v mantis_data:/data -v $(pwd):/backup alpine tar czf /backup/mantis-data.tar.gz /data
```

## Restore

```bash
# Restore database
docker compose exec -T mantis-db mysql -u mantis -pmantis bugtracker < mantis_backup.sql

# Restore files
docker run --rm -v mantis_data:/data -v $(pwd):/backup alpine tar xzf /backup/mantis-data.tar.gz -C /
```

## Customization

### Themes

1. Download theme
2. Place in `/var/www/html/css/`
3. Select in "Manage" → "Manage Configuration" → "Look and Feel"

### Plugins

1. Download plugin
2. Upload to `/var/www/html/plugins/`
3. Enable in "Manage" → "Manage Plugins"

## Monitoring

```bash
# View logs
docker compose logs -f mantis

# Check database
docker compose exec mantis-db mysql -u mantis -pmantis bugtracker -e "SELECT COUNT(*) FROM mantis_bug_table;"

# Check PHP version
docker compose exec mantis php -v
```

## Stop MantisBT

```bash
docker compose down
```

## Troubleshooting

### Cannot access UI

Wait for services to start:
```bash
docker compose logs -f
```

### Database connection error

Check database container:
```bash
docker compose ps mantis-db
docker compose logs mantis-db
```

### "Deprecated" warnings

These are normal PHP deprecation notices and don't affect functionality.

## Performance Tuning

For better performance:
- Enable PHP OpCache
- Optimize MySQL configuration
- Use caching for filters
- Archive old issues

## Security

1. **Change admin password** immediately
2. **Remove signup** if not needed: Manage → Configuration → Signup
3. **Configure email** for notifications
4. **Regular backups**
5. **Keep updated**: `docker compose pull && docker compose up -d`
6. **Use HTTPS** in production
7. **Restrict API access** with tokens
8. **Configure firewall**

## Comparison

| Feature | MantisBT | Redmine | Bugzilla |
|---------|----------|---------|----------|
| Language | PHP | Ruby | Perl |
| Database | MySQL | PostgreSQL/MySQL | MySQL/PostgreSQL |
| Complexity | Simple | Medium | Complex |
| Memory | 200MB | 500MB | 300MB |
| Best For | Bug tracking | Full PM | Enterprise bugs |
| UI | Traditional | Traditional | Traditional |

## Notes

- **Port 8989**: Web interface
- **Database**: MySQL 8.0
- **Language**: PHP
- **Memory**: ~200MB RAM
- **Startup**: 20-30 seconds
- **Lightweight**: Good for small teams
- **Similar to**: Bugzilla, JIRA (simpler)

## Resources

- [MantisBT Official Website](https://www.mantisbt.org/)
- [MantisBT Documentation](https://mantisbt.org/docs/)
- [MantisBT API](https://documenter.getpostman.com/view/29959/mantis-bug-tracker-rest-api/7TNfX8P)
- [MantisBT Plugins](https://www.mantisbt.org/bugs/plugin_list.php)
- [MantisBT GitHub](https://github.com/mantisbt/mantisbt)
