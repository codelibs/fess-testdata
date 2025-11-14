WordPress Test Environment
==========================

## Overview

This environment provides WordPress, the world's most popular Content Management System (CMS), for testing Fess CMS and blog content crawling capabilities.

## Run WordPress

```bash
docker compose up -d
```

Wait for WordPress and MySQL to initialize (takes 30-60 seconds on first run).

## Access WordPress

- **Website**: http://localhost:8080
- **Admin Panel**: http://localhost:8080/wp-admin

On first access, complete the WordPress installation:
1. Select language
2. Create admin account:
   - Username: admin
   - Password: (choose strong password)
   - Email: admin@example.com
3. Click "Install WordPress"

## Create Test Content

### Via Admin Panel

1. Login to http://localhost:8080/wp-admin
2. **Posts → Add New**: Create blog posts
3. **Pages → Add New**: Create static pages
4. **Media**: Upload images
5. **Settings → Permalinks**: Set to "Post name" for clean URLs

### Sample Content

Create these sample posts:

**Post 1: "Welcome to WordPress"**
```
Title: Welcome to WordPress
Content: This is a test blog post for Fess crawling. WordPress is a free and open-source content management system written in PHP.
Category: Blog
Tags: wordpress, cms, test
```

**Post 2: "WordPress Features"**
```
Title: WordPress Features
Content: WordPress powers over 40% of all websites. It offers themes, plugins, and a powerful content editor for creating any type of website.
Category: Features
Tags: wordpress, features, cms
```

**Page 1: "About"**
```
Title: About
Content: This is a test WordPress site for demonstrating Fess crawling capabilities with CMS content.
```

### Using WP-CLI

```bash
# Create posts via command line
docker compose exec wordpress wp post create \
  --post_title="Test Post" \
  --post_content="This is a test post content for Fess crawling." \
  --post_status=publish \
  --user=admin

# List posts
docker compose exec wordpress wp post list

# Create page
docker compose exec wordpress wp post create \
  --post_type=page \
  --post_title="Sample Page" \
  --post_content="This is a sample page content." \
  --post_status=publish \
  --user=admin
```

## Fess Configuration

### Web Crawl Configuration

Configure Fess to crawl WordPress site:

| Name | Value |
|:-----|:------|
| Name | WordPress Test |
| URL | http://localhost:8080/ |
| Depth | 3-5 |
| Max Access Count | 1000 |
| Included URLs | http://localhost:8080/.* |
| Excluded URLs | .*/wp-admin/.*, .*/wp-login.php |

**Crawl Targets:**
- Blog posts
- Pages
- Categories
- Tags
- Archives
- Search results (optional)

### REST API Access

WordPress provides REST API for programmatic access:

```bash
# Get posts
curl http://localhost:8080/wp-json/wp/v2/posts

# Get pages
curl http://localhost:8080/wp-json/wp/v2/pages

# Get categories
curl http://localhost:8080/wp-json/wp/v2/categories

# Get tags
curl http://localhost:8080/wp-json/wp/v2/tags

# Get media
curl http://localhost:8080/wp-json/wp/v2/media

# Search content
curl "http://localhost:8080/wp-json/wp/v2/search?search=wordpress"
```

### XML Sitemap

WordPress can generate XML sitemaps (via plugins like Yoast SEO):
```
http://localhost:8080/sitemap_index.xml
```

## WordPress Features

- **Content Management**: Posts, pages, media library
- **Themes**: Customizable design templates
- **Plugins**: Extend functionality
- **User Management**: Multiple user roles
- **SEO**: Built-in SEO features and plugins
- **Multilingual**: Translation ready
- **REST API**: Programmatic access to content
- **Widgets**: Sidebar and footer content blocks

## Configuration

- **Web Port**: 8080
- **Database**: MySQL 8.0
- **PHP**: Latest version
- **Default Theme**: Twenty Twenty-Four (or latest)

## Content Types

### Posts

Blog-style content with:
- Categories
- Tags
- Publication date
- Author
- Comments

### Pages

Static content:
- About
- Contact
- Services
- Privacy Policy

### Media

Upload images, documents:
```bash
docker compose exec wordpress wp media import /path/to/file.jpg
```

### Custom Post Types

Create custom content types via plugins or code.

## Use Cases for Fess

1. **Blog Search**: Index blog posts and make them searchable
2. **Knowledge Base**: Search documentation pages
3. **E-commerce**: Product catalog search (with WooCommerce)
4. **News Site**: Article and news search
5. **Corporate Site**: Company information and resources

## Integration Patterns

### Pattern 1: Web Crawling

Crawl WordPress as a regular website:
- Start from homepage
- Follow post and page links
- Extract title, content, metadata

### Pattern 2: REST API Integration

Use WordPress REST API:
- Structured data access
- Pagination support
- Filter by date, category, tag

### Pattern 3: RSS/Atom Feeds

Subscribe to content feeds:
```
http://localhost:8080/feed/
http://localhost:8080/category/blog/feed/
http://localhost:8080/tag/wordpress/feed/
```

## Administration

### User Management

```bash
# Create user
docker compose exec wordpress wp user create \
  testuser test@example.com \
  --role=author \
  --user_pass=testpass123

# List users
docker compose exec wordpress wp user list

# Update user role
docker compose exec wordpress wp user set-role testuser editor
```

### Plugin Management

```bash
# Install plugin
docker compose exec wordpress wp plugin install classic-editor --activate

# List plugins
docker compose exec wordpress wp plugin list

# Update plugins
docker compose exec wordpress wp plugin update --all
```

### Theme Management

```bash
# List themes
docker compose exec wordpress wp theme list

# Activate theme
docker compose exec wordpress wp theme activate twentytwentyfour

# Install theme
docker compose exec wordpress wp theme install twentytwentythree --activate
```

### Database Operations

```bash
# Export database
docker compose exec wordpress-db mysqldump -u wordpress -pwordpress123 wordpress > wordpress_backup.sql

# Import database
docker compose exec -T wordpress-db mysql -u wordpress -pwordpress123 wordpress < wordpress_backup.sql

# Search and replace URLs (if changing domain)
docker compose exec wordpress wp search-replace 'http://old-domain.com' 'http://localhost:8080'
```

## Monitoring

```bash
# Check WordPress version
docker compose exec wordpress wp core version

# Check site status
curl -I http://localhost:8080

# View logs
docker compose logs -f wordpress

# Database connection test
docker compose exec wordpress-db mysql -u wordpress -pwordpress123 -e "SHOW DATABASES;"
```

## Stop WordPress

```bash
docker compose down
```

## Backup

```bash
# Backup WordPress files
docker compose exec wordpress tar czf /tmp/wp-backup.tar.gz /var/www/html
docker compose cp wordpress:/tmp/wp-backup.tar.gz ./wp-backup.tar.gz

# Backup database
docker compose exec wordpress-db mysqldump -u wordpress -pwordpress123 wordpress > wp-db-backup.sql
```

## Performance Optimization

Install caching plugins:
```bash
docker compose exec wordpress wp plugin install w3-total-cache --activate
docker compose exec wordpress wp plugin install wp-super-cache --activate
```

Configure object caching with Redis (advanced):
```yaml
services:
  redis:
    image: redis:alpine
    container_name: wp-redis
```

## Security

1. **Change default credentials** after installation
2. **Update regularly**: WordPress core, plugins, themes
3. **Use security plugins**: Wordfence, Sucuri
4. **Configure .htaccess**: Protect wp-config.php
5. **Enable HTTPS** in production
6. **Disable file editing**: Add to wp-config.php:
   ```php
   define('DISALLOW_FILE_EDIT', true);
   ```

## Troubleshooting

### Cannot access website

Wait for containers to fully start:

```bash
docker compose logs -f
# Wait for "ready for connections" from MySQL
```

### Database connection error

Check database container:

```bash
docker compose ps
docker compose logs wordpress-db
```

### White screen / Error 500

Check PHP errors:

```bash
docker compose exec wordpress tail -f /var/log/apache2/error.log
```

Enable debug mode by editing wp-config.php:
```php
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
```

### Permission issues

Fix file permissions:

```bash
docker compose exec wordpress chown -R www-data:www-data /var/www/html
```

## Notes

- **Port 8080**: Web interface (avoid conflict with other services)
- **Database**: MySQL 8.0 with dedicated container
- **Data Persistence**: Both WordPress files and database stored in volumes
- **Memory**: Requires ~500MB RAM
- **Default Login**: Set during installation
- **Used by**: 40%+ of all websites worldwide

## Resources

- [WordPress Documentation](https://wordpress.org/support/)
- [REST API Handbook](https://developer.wordpress.org/rest-api/)
- [WP-CLI Documentation](https://wp-cli.org/)
- [Plugin Directory](https://wordpress.org/plugins/)
- [Theme Directory](https://wordpress.org/themes/)
