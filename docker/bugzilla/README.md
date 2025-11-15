Bugzilla Test Environment
==========================

## Overview

This environment provides Bugzilla, Mozilla's mature enterprise-grade bug tracking system, for testing Fess crawling of comprehensive bug tracking content.

## Run Bugzilla

```bash
docker compose up -d
```

Wait for Bugzilla to initialize (takes 60-90 seconds on first run for database setup).

## Access Bugzilla

- **URL**: http://localhost:8990
- **Admin Account**:
  - Email: admin@example.com
  - Password: bugzilla123

**Note**: Change the admin password after first login!

## Initial Setup

1. Open http://localhost:8990
2. Wait for initialization (60-90 seconds)
3. Click "Log In" (top right)
4. Login with admin@example.com / bugzilla123
5. Go to "Preferences" → Change password

## Create Test Data

### Create Product

1. Go to "Administration" → "Products"
2. Click "Add" new product
3. Fill in:
   - Product: Test Product
   - Description: Test product for Bugzilla and Fess
   - Version: 1.0
   - Component: General (auto-created)
4. Click "Save"

### Add Components

1. In product, click "Edit Components"
2. Add new component:
   - Component: Frontend
   - Description: Frontend issues
   - Default Assignee: admin@example.com
3. Repeat for: Backend, Database, Documentation

### Add Versions

1. In product, click "Edit Versions"
2. Add versions:
   - 1.0.0
   - 1.1.0
   - 2.0.0

### Create Bugs

1. Click "New" (top menu) or "File a Bug"
2. Select product: Test Product
3. Fill in bug details:

**Bug 1:**
- Component: Backend
- Version: 1.0.0
- Severity: major
- Priority: high
- Hardware: All
- OS: All
- Summary: Database connection timeout
- Description: Application fails to connect to database after 30 seconds
- Steps to Reproduce:
  1. Start application
  2. Wait for 30 seconds
  3. Observe timeout error
- Expected Results: Should connect successfully
- Actual Results: Connection timeout error

**Bug 2:**
- Component: Frontend
- Severity: normal
- Priority: normal
- Summary: Button misalignment on mobile
- Description: Submit button is not aligned properly on mobile devices

**Bug 3:**
- Component: Documentation
- Severity: enhancement
- Priority: low
- Summary: API documentation needed
- Description: Need comprehensive API documentation for developers

### Add Comments

1. Open a bug
2. Scroll to "Additional Comments"
3. Add comments:
   - "I can reproduce this issue"
   - "Fix implemented in commit abc123"
   - "Verified in version 1.1.0"

### Add Attachments

1. Open a bug
2. Click "Add an attachment"
3. Upload files (screenshots, logs, patches)

## Fess Configuration

### Web Crawl Configuration

Configure Fess to crawl Bugzilla:

| Name | Value |
|:-----|:------|
| Name | Bugzilla Test |
| URL | http://localhost:8990/ |
| Depth | 3-4 |
| Max Access Count | 2000 |

**Crawl Targets:**
- Bug listings
- Bug details and comments
- Product pages
- Search results
- Charts and reports

**Note**: Public bugs are crawlable. Configure authentication for private bugs.

### REST API / XML-RPC

Bugzilla provides XML-RPC API:

```bash
# Using curl with XML-RPC

# Login
curl http://localhost:8990/xmlrpc.cgi \
  -H "Content-Type: text/xml" \
  -d '<?xml version="1.0" encoding="UTF-8"?>
<methodCall>
  <methodName>User.login</methodName>
  <params>
    <param><value><string>admin@example.com</string></value></param>
    <param><value><string>bugzilla123</string></value></param>
  </params>
</methodCall>'

# Search bugs
curl http://localhost:8990/xmlrpc.cgi \
  -H "Content-Type: text/xml" \
  -d '<?xml version="1.0" encoding="UTF-8"?>
<methodCall>
  <methodName>Bug.search</methodName>
  <params>
    <param><value><string>Test</string></value></param>
  </params>
</methodCall>'

# Get specific bug
curl http://localhost:8990/xmlrpc.cgi \
  -H "Content-Type: text/xml" \
  -d '<?xml version="1.0" encoding="UTF-8"?>
<methodCall>
  <methodName>Bug.get</methodName>
  <params>
    <param><value><int>1</int></value></param>
  </params>
</methodCall>'
```

### Alternative: REST API (if enabled)

```bash
# Get bug details (JSON)
curl http://localhost:8990/rest/bug/1

# Search bugs
curl "http://localhost:8990/rest/bug?product=Test%20Product"

# Get comments
curl http://localhost:8990/rest/bug/1/comment
```

## Bugzilla Features

- **Bug Tracking**: Comprehensive defect tracking
- **Products**: Multi-product support
- **Components**: Organize by functional area
- **Versions**: Track across releases
- **Milestones**: Release planning
- **Dependencies**: Bug relationships
- **Flags**: Approval workflow
- **Custom Fields**: Extensible schema
- **Advanced Search**: Powerful query builder
- **Saved Searches**: Reusable queries
- **Charts and Reports**: Statistical analysis
- **Email Notifications**: Configurable alerts
- **Time Tracking**: Estimate and actual time
- **Whining**: Scheduled email reports
- **Keywords**: Flexible tagging
- **Groups**: Security and privacy

## Configuration

- **HTTP Port**: 8990
- **Database**: MySQL 8.0
- **Language**: Perl
- **Memory**: ~300MB RAM
- **Mature**: 20+ years of development

## User Management

### Create Users

1. "Administration" → "Users"
2. Click "add a new user"
3. Fill in:
   - Login name: testuser@example.com
   - Real name: Test User
   - Password: testpass123
4. Click "Submit"

### User Groups

1. "Administration" → "Groups"
2. Create group or add users to existing groups:
   - admin
   - editbugs
   - canconfirm
   - etc.

## Product Configuration

### Product Settings

1. "Administration" → "Products"
2. Click product name
3. Configure:
   - Versions: Add/edit versions
   - Components: Add/edit components
   - Milestones: Add target milestones
   - Group Access Control: Set visibility

### Bug Fields

1. "Administration" → "Field Values"
2. Customize:
   - Bug Status: NEW, ASSIGNED, RESOLVED, VERIFIED, CLOSED
   - Resolution: FIXED, INVALID, WONTFIX, DUPLICATE
   - Priority: P1-P5
   - Severity: blocker, critical, major, normal, minor, trivial, enhancement

### Custom Fields

1. "Administration" → "Custom Fields"
2. Click "Add a new custom field"
3. Create field:
   - Name: customer_name
   - Description: Customer Name
   - Type: Free Text
   - Sort Key: 100

## Advanced Features

### Bug Dependencies

1. Edit bug
2. Find "Depends on" and "Blocks" fields
3. Enter bug IDs to create relationships

### Flags

1. "Administration" → "Flags"
2. Create flag type (e.g., "review+/review-")
3. Use flags for approval workflow

### Saved Searches

1. Use "Search" to build query
2. Click "Remember search" at bottom
3. Name and save search
4. Access from footer

### Charts and Reports

1. "Reports" menu
2. Available reports:
   - Duplicates Report
   - Change Reports
   - Graphical Reports
   - Old Charts
   - Tabular Reports

## Email Configuration

Configure in Administration → Parameters → Email:

- `mail_delivery_method`: SMTP
- `mailfrom`: bugzilla@example.com
- `smtpserver`: smtp.example.com
- `smtp_username`: user
- `smtp_password`: password

## Use Cases for Fess

1. **Bug Search**: Full-text search across all bugs
2. **Comment Search**: Find solutions in bug comments
3. **Historical Search**: Search resolved/closed bugs
4. **Knowledge Base**: Index fixed bugs as knowledge
5. **Cross-Product Search**: Search bugs across products
6. **Attachment Search**: Index attached documents

## Integration Patterns

### Pattern 1: Web Crawling

Crawl Bugzilla as website:
- Follow bug links
- Extract bug details
- Index descriptions and comments

### Pattern 2: XML-RPC API

Use Bugzilla XML-RPC:
- Search bugs
- Get bug details
- Structured data access

### Pattern 3: REST API

Use REST endpoints (if enabled):
- JSON format
- Modern integration
- Easier parsing

### Pattern 4: RSS Feeds

Subscribe to bug feeds:
```
http://localhost:8990/buglist.cgi?...&ctype=atom
```

### Pattern 5: Database Access

Direct database crawling:
- Connect to MySQL
- Query bugs, longdescs tables
- Most complete access

## Backup

```bash
# Backup database
docker compose exec bugzilla-db mysqldump -u bugs -pbugs bugs > bugzilla_backup.sql

# Backup data directory
docker run --rm -v bugzilla_data:/data -v $(pwd):/backup alpine tar czf /backup/bugzilla-data.tar.gz /data
```

## Restore

```bash
# Restore database
docker compose exec -T bugzilla-db mysql -u bugs -pbugs bugs < bugzilla_backup.sql

# Restore data
docker run --rm -v bugzilla_data:/data -v $(pwd):/backup alpine tar xzf /backup/bugzilla-data.tar.gz -C /
```

## Administration Tasks

### Check Database

```bash
docker compose exec bugzilla-db mysql -u bugs -pbugs bugs -e "SELECT COUNT(*) FROM bugs;"
```

### Check Configuration

http://localhost:8990/editparams.cgi

### Run checksetup.pl

```bash
docker compose exec bugzilla /var/www/html/bugzilla/checksetup.pl
```

## Monitoring

```bash
# View logs
docker compose logs -f bugzilla

# Check database size
docker compose exec bugzilla-db mysql -u bugs -pbugs -e "
  SELECT table_name,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Size (MB)'
  FROM information_schema.TABLES
  WHERE table_schema = 'bugs'
  ORDER BY (data_length + index_length) DESC;"
```

## Stop Bugzilla

```bash
docker compose down
```

## Troubleshooting

### Long initialization time

First startup takes 60-90 seconds for database schema creation. Check logs:

```bash
docker compose logs -f bugzilla
# Wait for "Apache started"
```

### Cannot login

Check admin credentials in compose.yaml `ADMIN_EMAIL` and `ADMIN_PASSWORD`.

### Database errors

Check database container:
```bash
docker compose ps bugzilla-db
docker compose logs bugzilla-db
```

### "Insecure dependency" errors

These are Perl taint mode warnings, usually safe in Docker.

## Performance Tuning

For large installations:
- Enable memcached
- Optimize MySQL configuration
- Archive old bugs
- Use mod_perl for better performance

## Security

1. **Change admin password** immediately
2. **Configure SSL/HTTPS** in production
3. **Regular backups**
4. **Keep updated**: Bugzilla releases security fixes
5. **Restrict API access** with API keys
6. **Use groups** for bug privacy
7. **Configure email** properly
8. **Disable unused features**

## Comparison

| Feature | Bugzilla | MantisBT | Redmine |
|---------|----------|----------|---------|
| Age | 25+ years | 20+ years | 15+ years |
| Language | Perl | PHP | Ruby |
| Complexity | High | Low | Medium |
| Features | Very comprehensive | Basic | Comprehensive |
| Best For | Enterprise bugs | Small teams | Project mgmt |
| Learning Curve | Steep | Easy | Medium |

## Notes

- **Port 8990**: Web interface
- **Database**: MySQL 8.0
- **Language**: Perl
- **Memory**: ~300MB RAM
- **Startup**: 60-90 seconds first time
- **Enterprise**: Used by Mozilla, Linux Kernel, Apache, etc.
- **Similar to**: JIRA (older), HP Quality Center

## Resources

- [Bugzilla Official Website](https://www.bugzilla.org/)
- [Bugzilla Documentation](https://www.bugzilla.org/docs/)
- [Bugzilla API](https://www.bugzilla.org/docs/tip/en/html/api/)
- [Bugzilla Guide](https://www.bugzilla.org/docs/tip/en/html/using.html)
- [Bugzilla GitHub](https://github.com/bugzilla/bugzilla)
