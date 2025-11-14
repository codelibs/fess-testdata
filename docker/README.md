# Fess Test Docker Environments

This directory contains comprehensive Docker-based test environments for testing [Fess](https://fess.codelibs.org/) crawling capabilities across various data sources, protocols, and systems.

## Available Environments (21 Total)

### Web Server Environments

#### 1. Basic Authentication (`basic/`)
- **Purpose**: Test HTTP Basic Authentication
- **URL**: http://localhost:10080
- **Credentials**: testuser / test
- **Start**: `cd basic && docker compose up -d`

#### 2. Digest Authentication (`digest/`)
- **Purpose**: Test HTTP Digest Authentication
- **URL**: http://localhost:18080
- **Credentials**: test / test
- **Start**: `cd digest && docker compose up -d`

#### 3. Self-Signed SSL (`self_signed/`)
- **Purpose**: Test HTTPS with self-signed certificates
- **URLs**: http://localhost:10080, https://localhost:10443
- **Start**: `cd self_signed && docker compose up -d`

### File Server Environments

#### 4. FTP Server (`ftp/`)
- **Purpose**: Test FTP protocol crawling
- **Port**: 10021
- **Credentials**: testuser1 / test123
- **Start**: `cd ftp && docker compose up -d --build`

#### 5. Samba/SMB Server (`samba/`)
- **Purpose**: Test SMB/CIFS file sharing
- **Ports**: 1139 (SMB), 1445 (CIFS)
- **Credentials**: testuser1 or testuser2 / test123
- **Start**: `cd samba && docker compose up -d`

#### 6. WebDAV Server (`webdav/`)
- **Purpose**: Test WebDAV protocol crawling
- **URL**: http://localhost:10080
- **Credentials**: testuser / testpass
- **Start**: `cd webdav && docker compose up -d`

### Relational Database Environments

#### 7. MySQL (`mysql/`)
- **Purpose**: Test MySQL database crawling
- **Port**: 3306
- **Database**: testdb
- **Credentials**: hoge / fuga
- **Start**: `cd mysql && docker compose up -d`

#### 8. PostgreSQL (`postgresql/`)
- **Purpose**: Test PostgreSQL database crawling
- **Port**: 5432
- **Database**: testdb
- **Credentials**: testuser / testpass
- **Start**: `cd postgresql && docker compose up -d`

#### 9. MariaDB (`mariadb/`)
- **Purpose**: Test MariaDB (MySQL-compatible) database crawling
- **Port**: 3307
- **Database**: testdb
- **Credentials**: testuser / testpass
- **Start**: `cd mariadb && docker compose up -d`

#### 10. Microsoft SQL Server (`mssql/`)
- **Purpose**: Test SQL Server database crawling
- **Port**: 1433
- **Database**: testdb
- **Credentials**: sa / MyStrongPass123!
- **Start**: `cd mssql && docker compose up -d`
- **Note**: Requires 2GB+ RAM

### NoSQL Database Environments

#### 11. MongoDB (`mongodb/`)
- **Purpose**: Test MongoDB document database crawling
- **Port**: 27017
- **Database**: testdb
- **Credentials**: admin / admin123
- **Start**: `cd mongodb && docker compose up -d`

#### 12. CouchDB (`couchdb/`)
- **Purpose**: Test CouchDB document database crawling
- **Port**: 5984
- **Web UI**: http://localhost:5984/_utils/
- **Credentials**: admin / admin123
- **Start**: `cd couchdb && docker compose up -d`

#### 13. Cassandra (`cassandra/`)
- **Purpose**: Test Cassandra distributed database crawling
- **Port**: 9042 (CQL)
- **Keyspace**: testdb
- **Start**: `cd cassandra && docker compose up -d`
- **Note**: Requires 2GB+ RAM, 60-90s startup time

#### 14. Redis (`redis/`)
- **Purpose**: Test Redis key-value store crawling
- **Port**: 6379
- **Password**: redis123
- **Start**: `cd redis && docker compose up -d`

### Search Engine Environments

#### 15. Elasticsearch (`elasticsearch/`)
- **Purpose**: Test Elasticsearch search engine integration
- **Port**: 9200 (HTTP), 9300 (Transport)
- **Index**: documents
- **Start**: `cd elasticsearch && docker compose up -d`
- **Note**: Fess uses Elasticsearch internally

#### 16. Apache Solr (`solr/`)
- **Purpose**: Test Apache Solr search platform integration
- **Port**: 8983
- **Core**: documents
- **Admin UI**: http://localhost:8983/solr/
- **Start**: `cd solr && docker compose up -d`

### Object Storage & Cloud

#### 17. MinIO (`minio/`)
- **Purpose**: Test S3-compatible object storage crawling
- **API Port**: 9000
- **Console Port**: 9001
- **Console UI**: http://localhost:9001
- **Credentials**: minioadmin / minioadmin123
- **Start**: `cd minio && docker compose up -d`

### Directory Service

#### 18. LDAP (`ldap/`)
- **Purpose**: Test LDAP authentication and directory services
- **Ports**: 389 (LDAP), 636 (LDAPS), 8081 (phpLDAPadmin)
- **Admin DN**: cn=admin,dc=fess,dc=codelibs,dc=org
- **Admin Password**: admin
- **Start**: `cd ldap && docker compose up -d`

### Content Management & Collaboration

#### 19. WordPress (`wordpress/`)
- **Purpose**: Test WordPress CMS content crawling
- **Port**: 8080
- **Admin**: http://localhost:8080/wp-admin
- **Database**: MySQL (included)
- **Start**: `cd wordpress && docker compose up -d`
- **Note**: Complete setup wizard on first access

#### 20. Gitea (`gitea/`)
- **Purpose**: Test Git repository and code search
- **Port**: 3000 (HTTP), 2222 (SSH)
- **Web UI**: http://localhost:3000
- **Start**: `cd gitea && docker compose up -d`
- **Note**: Complete initial setup on first access

## Quick Start

### Start Specific Environment

```bash
# Example: Start PostgreSQL environment
cd postgresql
docker compose up -d

# View logs
docker compose logs -f

# Stop environment
docker compose down
```

### Start Multiple Environments

```bash
# Start all relational databases
for dir in mysql postgresql mariadb mssql; do
    (cd $dir && docker compose up -d)
done

# Start all NoSQL databases
for dir in mongodb couchdb cassandra redis; do
    (cd $dir && docker compose up -d)
done
```

## Requirements

- **Docker Engine**: 20.10+
- **Docker Compose**: V2 (using `docker compose` command, not `docker-compose`)
- **RAM**: Minimum 4GB recommended
  - 8GB+ recommended if running multiple databases
  - Some environments require more (SQL Server, Cassandra: 2GB+ each)
- **Disk Space**: 10GB+ recommended for all environments

## Port Reference

Quick reference of all ports used:

| Port(s) | Service | Environment |
|---------|---------|-------------|
| 389, 636, 8081 | LDAP, LDAPS, phpLDAPadmin | ldap |
| 1139, 1445 | SMB, CIFS | samba |
| 1433 | SQL Server | mssql |
| 2222 | SSH (Git) | gitea |
| 3000 | Gitea Web | gitea |
| 3306 | MySQL | mysql |
| 3307 | MariaDB | mariadb |
| 5432 | PostgreSQL | postgresql |
| 5984 | CouchDB | couchdb |
| 6379 | Redis | redis |
| 8080 | WordPress | wordpress |
| 8983 | Apache Solr | solr |
| 9000, 9001 | MinIO API, Console | minio |
| 9042, 7199 | Cassandra CQL, JMX | cassandra |
| 9200, 9300 | Elasticsearch | elasticsearch |
| 10021, 30000-30009 | FTP | ftp |
| 10080 | HTTP (various) | basic, webdav |
| 10443 | HTTPS | basic, self_signed |
| 18080 | HTTP (Digest Auth) | digest |
| 27017 | MongoDB | mongodb |

## Docker Compose V2

All environments use modern Docker Compose V2 format:

- **Command**: `docker compose` (not `docker-compose`)
- **Format**: No `version:` field (deprecated in V2)
- **Features**: Named volumes, restart policies, latest images

### Migration from V1

If you're upgrading from older compose files:

```bash
# Old command (V1)
docker-compose up -d

# New command (V2)
docker compose up -d
```

## Environment Categories

### By Data Type

- **Web Content**: basic, digest, self_signed, wordpress, gitea
- **Files**: ftp, samba, webdav, minio
- **Structured Data**: mysql, postgresql, mariadb, mssql, mongodb
- **Key-Value**: redis, couchdb
- **Distributed**: cassandra, elasticsearch, solr
- **Authentication**: ldap

### By Use Case

- **E-commerce**: wordpress + mysql
- **Enterprise**: mssql + ldap
- **Big Data**: cassandra + elasticsearch
- **Cloud Storage**: minio + s3
- **Development**: gitea + postgresql
- **Document Management**: webdav + postgresql

## Common Commands

```bash
# Start an environment
cd <environment-name>
docker compose up -d

# View logs
docker compose logs -f

# Check status
docker compose ps

# Stop environment
docker compose down

# Stop and remove volumes (clean slate)
docker compose down -v

# Rebuild containers
docker compose up -d --build

# Execute command in container
docker compose exec <service-name> <command>
```

## Data Initialization

Most environments include initialization scripts:

```bash
# Example: Initialize PostgreSQL with sample data
cd postgresql
docker compose up -d
sleep 10  # Wait for startup
# Data is auto-loaded from data/sql/init.sql

# Example: Load data into Elasticsearch
cd elasticsearch
docker compose up -d
sleep 30  # Wait for startup
./data/load_data.sh
```

## Troubleshooting

### Port Conflicts

If you encounter port conflicts:

```yaml
# Edit compose.yaml
ports:
  - "NEW_HOST_PORT:CONTAINER_PORT"
```

### Memory Issues

Some databases need more memory:

```bash
# Check Docker memory allocation
docker info | grep Memory

# Increase in Docker Desktop:
# Settings → Resources → Memory → 8GB
```

### Startup Time

Some services take time to initialize:

- **Fast** (5-10s): Redis, FTP, WebDAV, Basic Auth
- **Medium** (15-30s): MySQL, PostgreSQL, MariaDB, MongoDB, Elasticsearch
- **Slow** (30-60s): SQL Server, WordPress, Solr
- **Very Slow** (60-90s): Cassandra, Gitea (first time)

### Container Logs

Check logs for startup issues:

```bash
docker compose logs -f <service-name>
```

### Volume Permissions

Fix permission issues:

```bash
# For directories that need specific permissions
sudo chown -R 1000:1000 ./data
chmod -R 755 ./data
```

## Best Practices

### For Development

1. **Start small**: Begin with 1-2 environments
2. **Clean up**: Use `docker compose down -v` when done
3. **Monitor resources**: Check `docker stats`
4. **Read logs**: Use `docker compose logs` for debugging

### For Testing

1. **Consistent data**: Use provided init scripts
2. **Isolated networks**: Each compose file creates own network
3. **Snapshot volumes**: Backup volumes before destructive tests
4. **Document configs**: Note any Fess config changes

### For Production

1. **Change passwords**: Update all default credentials
2. **Enable SSL/TLS**: Configure HTTPS where applicable
3. **Set up monitoring**: Use proper logging and metrics
4. **Regular backups**: Automate data backups
5. **Resource limits**: Set memory/CPU limits in compose files

## Integration with Fess

Each environment README includes:

1. **Connection details**: Hosts, ports, credentials
2. **Fess configuration**: Specific settings for crawling
3. **Sample data**: Scripts to populate test data
4. **API examples**: How to query/access data

General integration steps:

1. **Start environment**: `docker compose up -d`
2. **Initialize data**: Run provided setup scripts
3. **Configure Fess**: Follow environment README
4. **Start crawl**: Begin crawling in Fess
5. **Verify results**: Check indexed documents

## Contributing

To add a new test environment:

1. Create directory under `docker/`
2. Add `compose.yaml` with service definitions
3. Create `README.md` with:
   - Overview and purpose
   - Setup instructions
   - Fess configuration guide
   - Sample data and usage examples
4. Add initialization scripts if needed
5. Update this main README

## Maintenance

### Updating Images

```bash
# Pull latest images
cd <environment>
docker compose pull

# Recreate containers
docker compose up -d --force-recreate
```

### Cleaning Up

```bash
# Stop all containers
docker compose down

# Remove unused volumes
docker volume prune

# Remove unused images
docker image prune

# Complete cleanup (careful!)
docker system prune -a --volumes
```

## Resources

- [Fess Official Website](https://fess.codelibs.org/)
- [Fess GitHub](https://github.com/codelibs/fess)
- [Fess Documentation](https://fess.codelibs.org/latest/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Hub](https://hub.docker.com/)

## License

These test environments are part of the fess-testdata repository.

## Support

For issues or questions:
- Check individual environment README files
- Review container logs
- Consult official documentation for each service
- Open issue on GitHub if needed
