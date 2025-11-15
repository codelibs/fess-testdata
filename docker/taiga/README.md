Taiga Test Environment
=======================

## Overview

This environment provides Taiga, a modern open-source agile project management platform with beautiful UI, for testing Fess crawling of agile/scrum project content.

## Run Taiga

```bash
docker compose up -d
```

Wait for all services to start (takes 30-60 seconds on first run).

## Access Taiga

- **URL**: http://localhost:9000
- **Default Admin Account**:
  - Username: `admin`
  - Password: `123123`

**IMPORTANT**: Change the admin password after first login!

## Initial Setup

1. Open http://localhost:9000
2. Click "Login"
3. Login with admin/123123
4. Go to user menu (top right) → "Change password"
5. Set a new password

## Create Test Data

### Create Project

1. Click "+" → "Create Project"
2. Select template:
   - Scrum
   - Kanban
   - Issues tracking
3. Fill in:
   - Name: Test Project
   - Description: Test project for Fess crawling
   - Creation template: Scrum
4. Click "Create project"

### Create User Stories

1. Go to project → "BACKLOG"
2. Click "+ New user story"
3. Create sample user stories:

**Story 1:**
- Subject: As a user, I want to login
- Description: User authentication functionality
- Points: 5
- Status: New

**Story 2:**
- Subject: As a user, I want to search documents
- Description: Full-text search feature
- Points: 8
- Status: In progress

**Story 3:**
- Subject: As an admin, I want to manage users
- Description: User management interface
- Points: 13
- Status: Ready

### Create Tasks

1. Open a user story
2. Click "+ Add task"
3. Create tasks:
   - Design login form (To Do)
   - Implement authentication API (In Progress)
   - Write unit tests (Done)

### Create Issues

1. Go to project → "ISSUES"
2. Click "+ New issue"
3. Create sample issues:

**Issue 1:**
- Subject: Login button not working
- Type: Bug
- Priority: High
- Status: New

**Issue 2:**
- Subject: Slow search performance
- Type: Question
- Priority: Normal
- Status: In progress

### Create Wiki Pages

1. Go to project → "WIKI"
2. Click "+ Create page"
3. Create pages:

**Home:**
```markdown
# Project Documentation

Welcome to the test project wiki.

## Links
- [Installation](installation)
- [API Documentation](api-docs)
- [User Guide](user-guide)
```

**Installation:**
```markdown
# Installation Guide

## Prerequisites
- Python 3.8+
- PostgreSQL
- Redis

## Steps
1. Clone repository
2. Install dependencies: `pip install -r requirements.txt`
3. Run migrations: `python manage.py migrate`
4. Start server: `python manage.py runserver`
```

### Set Up Sprint

1. Go to "BACKLOG"
2. Click "New sprint"
3. Name: Sprint 1
4. Start date: Today
5. End date: 2 weeks from now
6. Drag user stories into sprint
7. Click "Start sprint"

### Use Kanban Board

1. Go to "KANBAN"
2. Drag cards between columns:
   - New
   - In progress
   - Ready for test
   - Done

## Fess Configuration

### Web Crawl Configuration

Configure Fess to crawl Taiga:

| Name | Value |
|:-----|:------|
| Name | Taiga Test |
| URL | http://localhost:9000/ |
| Depth | 4-5 |
| Max Access Count | 2000 |

**Crawl Targets:**
- Project pages
- User stories
- Tasks
- Issues
- Wiki pages
- Sprint information
- Team members

**Note**: Public projects are crawlable without authentication. For private projects, configure web authentication.

### REST API Access

Taiga provides comprehensive REST API:

```bash
# Login and get auth token
curl -X POST http://localhost:9000/api/v1/auth \
  -H "Content-Type: application/json" \
  -d '{
    "type": "normal",
    "username": "admin",
    "password": "123123"
  }'

# Get projects (with token)
curl http://localhost:9000/api/v1/projects \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN"

# Get user stories
curl http://localhost:9000/api/v1/userstories \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN"

# Get tasks
curl http://localhost:9000/api/v1/tasks \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN"

# Get issues
curl http://localhost:9000/api/v1/issues \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN"

# Get wiki pages
curl http://localhost:9000/api/v1/wiki \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN"

# Search
curl "http://localhost:9000/api/v1/search?project=1&text=login" \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN"
```

## Taiga Features

- **Agile Boards**: Scrum and Kanban boards
- **User Stories**: Product backlog management
- **Tasks**: Breakdown of user stories
- **Issues**: Bug and issue tracking
- **Wiki**: Project documentation
- **Epics**: High-level features
- **Sprints**: Time-boxed iterations
- **Burndown Charts**: Progress visualization
- **Custom Fields**: Extensible data model
- **Team Management**: Roles and permissions
- **Webhooks**: Integration support
- **Video Calls**: Built-in video conferencing
- **Import/Export**: GitHub, Jira, Trello import

## Configuration

- **HTTP Port**: 9000
- **Database**: PostgreSQL 15
- **Architecture**: Frontend (Angular) + Backend (Django)
- **Reverse Proxy**: nginx

## User Management

### Create Users

1. Go to Admin panel (admin user only)
2. Click "Users"
3. Click "+ Create user"
4. Fill in:
   - Full name: Test User
   - Username: testuser
   - Email: test@example.com
   - Password: testpass123
5. Click "Save"

### Add Team Members

1. Go to project → "SETTINGS" → "MEMBERS"
2. Click "+ New member"
3. Enter email or username
4. Select role:
   - Admin: Full access
   - Member: Can manage content
   - Viewer: Read-only access
5. Click "Add member"

## Project Configuration

### Enable Modules

1. Go to project → "SETTINGS" → "MODULES"
2. Enable/disable modules:
   - Timeline ✓
   - Epics
   - Backlog ✓
   - Kanban ✓
   - Issues ✓
   - Wiki ✓
   - Video calls

### Custom Fields

1. "SETTINGS" → "ATTRIBUTES"
2. Create custom fields for:
   - User stories (e.g., Business value)
   - Tasks (e.g., Estimated hours)
   - Issues (e.g., Affected version)

### Workflow Statuses

1. "SETTINGS" → "ATTRIBUTES" → "Statuses"
2. Customize statuses for:
   - User stories: New → In progress → Ready for test → Done → Archived
   - Tasks: New → In progress → Ready for test → Done
   - Issues: New → In progress → Ready for test → Done → Closed

## Integration

### Webhooks

1. "SETTINGS" → "INTEGRATIONS" → "WEBHOOKS"
2. Click "+ Add webhook"
3. Configure:
   - Name: Fess Integration
   - URL: http://your-fess-server/webhook
   - Secret key: (optional)
   - Events: All events

### GitHub Integration

1. "SETTINGS" → "INTEGRATIONS" → "GITHUB"
2. Configure repository
3. Link commits to user stories

### Slack Integration

1. "SETTINGS" → "INTEGRATIONS" → "SLACK"
2. Configure webhook URL
3. Select events to notify

## Use Cases for Fess

1. **User Story Search**: Find stories across projects
2. **Issue Tracking**: Search bugs and issues
3. **Wiki Search**: Documentation search
4. **Sprint Content**: Search sprint planning content
5. **Comment Search**: Find discussions and comments
6. **Cross-Project**: Search across multiple projects

## Integration Patterns

### Pattern 1: Web Crawling

Crawl Taiga as website:
- Follow project links
- Extract user stories, tasks, issues
- Index wiki content

### Pattern 2: REST API

Use Taiga API:
- List all projects
- Get user stories, tasks, issues
- Structured data access
- Real-time updates

### Pattern 3: Webhooks

Receive real-time notifications:
- Story created/updated
- Task status changed
- Issue commented
- Trigger incremental crawls

## Backup

```bash
# Backup database
docker compose exec taiga-db pg_dump -U taiga taiga > taiga_backup.sql

# Backup media files
docker run --rm -v taiga_media:/data -v $(pwd):/backup alpine tar czf /backup/taiga-media.tar.gz /data
```

## Restore

```bash
# Restore database
docker compose exec -T taiga-db psql -U taiga taiga < taiga_backup.sql

# Restore media files
docker run --rm -v taiga_media:/data -v $(pwd):/backup alpine tar xzf /backup/taiga-media.tar.gz -C /
```

## Administration

### Django Admin

Access Django admin panel:

1. Open http://localhost:9000/admin/
2. Login with admin/123123
3. Manage database directly

### Create Superuser

```bash
docker compose exec taiga-back python manage.py createsuperuser
```

### Database Access

```bash
# Connect to PostgreSQL
docker compose exec taiga-db psql -U taiga taiga

# Example queries
taiga=# SELECT COUNT(*) FROM projects_project;
taiga=# SELECT * FROM userstories_userstory LIMIT 5;
```

## Monitoring

```bash
# Check services
docker compose ps

# View logs
docker compose logs -f taiga-back

# Check database
docker compose exec taiga-db psql -U taiga -d taiga -c "SELECT COUNT(*) FROM projects_project;"

# Check media storage
docker compose exec taiga-back du -sh /taiga-back/media
```

## Stop Taiga

```bash
docker compose down
```

## Troubleshooting

### Cannot access UI

Wait for services to start:

```bash
docker compose logs -f
# Wait for all services to be ready
```

Check nginx configuration:
```bash
docker compose exec taiga-gateway nginx -t
```

### API errors

Check backend logs:
```bash
docker compose logs -f taiga-back
```

### Database connection error

Check database container:
```bash
docker compose ps taiga-db
docker compose logs taiga-db
```

### Static files not loading

Restart services:
```bash
docker compose restart
```

## Performance Tuning

For better performance:

```yaml
# In taiga-back service
environment:
  DJANGO_DEBUG: "False"
  CELERY_ENABLED: "True"
```

Consider adding Redis for caching.

## Security

1. **Change admin password** immediately
2. **Use strong passwords** for all users
3. **Enable HTTPS** in production
4. **Regular backups**
5. **Keep updated**: `docker compose pull && docker compose up -d`
6. **Configure CORS** properly
7. **Use secret key** in production
8. **Restrict admin access**

## Comparison

| Feature | Taiga | Redmine | GitLab Issues |
|---------|-------|---------|---------------|
| UI | Modern | Traditional | Modern |
| Focus | Agile/Scrum | Traditional PM | DevOps |
| Learning Curve | Easy | Medium | Medium |
| Features | Agile-focused | Comprehensive | Developer-focused |
| Memory | ~500MB | ~500MB | 4GB+ |

## Notes

- **Port 9000**: Web interface
- **Database**: PostgreSQL 15
- **Frontend**: Angular
- **Backend**: Django (Python)
- **Memory**: ~500MB RAM
- **Startup**: 30-60 seconds
- **Similar to**: Jira Agile, Rally, VersionOne

## Resources

- [Taiga Official Website](https://taiga.io/)
- [Taiga Documentation](https://docs.taiga.io/)
- [Taiga API](https://docs.taiga.io/api.html)
- [Taiga Community](https://community.taiga.io/)
- [Import from Jira/GitHub/Trello](https://docs.taiga.io/importers.html)
