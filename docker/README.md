# Fess Test Docker Environments

This directory contains various Docker-based test environments for testing [Fess](https://fess.codelibs.org/) crawling capabilities.

## Available Environments

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

### Database Environments

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

#### 9. MongoDB (`mongodb/`)
- **Purpose**: Test MongoDB NoSQL database crawling
- **Port**: 27017
- **Database**: testdb
- **Credentials**: admin / admin123
- **Start**: `cd mongodb && docker compose up -d`

### Directory Service Environments

#### 10. LDAP (`ldap/`)
- **Purpose**: Test LDAP authentication and directory services
- **Ports**: 389 (LDAP), 636 (LDAPS), 8081 (phpLDAPadmin)
- **Admin DN**: cn=admin,dc=fess,dc=codelibs,dc=org
- **Admin Password**: admin
- **Start**: `cd ldap && docker compose up -d`

## Quick Start

### Start All Environments

```bash
# Start all environments (not recommended for development)
for dir in basic digest self_signed ftp samba webdav mysql postgresql mongodb ldap; do
    (cd $dir && docker compose up -d)
done
```

### Start Specific Environment

```bash
# Example: Start MySQL environment
cd mysql
docker compose up -d

# View logs
docker compose logs -f

# Stop environment
docker compose down
```

## Requirements

- Docker Engine 20.10+
- Docker Compose V2 (using `docker compose` command)
- Minimum 4GB RAM recommended
- Ports: Ensure the following ports are available:
  - 10080, 10443 (basic, self_signed, webdav)
  - 18080 (digest)
  - 10021, 30000-30009 (ftp)
  - 1139, 1445 (samba)
  - 3306 (mysql)
  - 5432 (postgresql)
  - 27017 (mongodb)
  - 389, 636, 8081 (ldap)

## Docker Compose V2

All environments have been updated to use modern Docker Compose V2 format:

- **Old command**: `docker-compose up`
- **New command**: `docker compose up`
- **Changes**:
  - Removed `version:` field (deprecated)
  - Updated to latest image versions
  - Added named volumes for data persistence
  - Added `restart: unless-stopped` policies
  - Improved configuration for production-like setup

## Directory Structure

```
docker/
├── README.md                    # This file
├── basic/                       # Basic auth environment
│   ├── compose.yaml
│   ├── README.md
│   └── var/
├── digest/                      # Digest auth environment
│   ├── compose.yaml
│   ├── README.md
│   └── var/
├── self_signed/                 # Self-signed SSL environment
│   ├── compose.yaml
│   └── README.md
├── ftp/                         # FTP server
│   ├── compose.yaml
│   ├── README.md
│   ├── Dockerfile
│   └── data/
├── samba/                       # Samba/SMB server
│   ├── compose.yaml
│   ├── README.md
│   └── data/
├── webdav/                      # WebDAV server
│   ├── compose.yaml
│   ├── README.md
│   └── data/
├── mysql/                       # MySQL database
│   ├── compose.yaml
│   ├── README.md
│   └── data/
├── postgresql/                  # PostgreSQL database
│   ├── compose.yaml
│   ├── README.md
│   └── data/
├── mongodb/                     # MongoDB database
│   ├── compose.yaml
│   ├── README.md
│   └── data/
└── ldap/                        # LDAP directory
    ├── compose.yaml
    ├── README.md
    └── fess_codelibs_org.ldif
```

## Usage with Fess

Each environment directory contains a detailed README.md with:

1. **Overview**: Description of the test environment
2. **Setup Instructions**: How to start and stop the service
3. **Connection Details**: URLs, ports, credentials
4. **Fess Configuration**: Specific settings for configuring Fess to crawl the environment
5. **Manual Testing**: How to manually test the environment

Please refer to individual README.md files in each directory for detailed configuration instructions.

## Common Commands

```bash
# Start an environment
cd <environment-name>
docker compose up -d

# View logs
docker compose logs -f

# Stop an environment
docker compose down

# Stop and remove volumes (clean slate)
docker compose down -v

# Rebuild containers
docker compose up -d --build

# Check running containers
docker compose ps
```

## Troubleshooting

### Port Conflicts

If you encounter port conflicts, you can modify the port mappings in the `compose.yaml` files:

```yaml
ports:
  - "NEW_PORT:CONTAINER_PORT"
```

### Volume Permissions

Some environments may require specific permissions for mounted volumes:

```bash
# Fix permissions for FTP
chmod 755 ftp/data

# Fix permissions for Samba
chmod 755 samba/data
```

### Container Logs

Check container logs for errors:

```bash
cd <environment-name>
docker compose logs -f
```

## Contributing

To add a new test environment:

1. Create a new directory under `docker/`
2. Add `compose.yaml` with the service definition
3. Create `README.md` with setup and usage instructions
4. Add sample data if applicable
5. Update this main README.md with the new environment

## License

These test environments are part of the fess-testdata repository and follow the same license.

## Related Resources

- [Fess Official Website](https://fess.codelibs.org/)
- [Fess GitHub Repository](https://github.com/codelibs/fess)
- [Fess Documentation](https://fess.codelibs.org/latest/)
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
