# Keycloak Test Environment

Keycloak is an open-source Identity and Access Management solution supporting OpenID Connect, OAuth 2.0, and SAML 2.0 protocols.

## Services

- **Keycloak**: Authentication server (Red Hat SSO upstream)
- **PostgreSQL**: Backend database for Keycloak

## Quick Start

```bash
# Start services
docker compose up -d

# Check logs
docker compose logs -f keycloak

# Stop services
docker compose down

# Remove all data
docker compose down -v
```

## Access Information

### Keycloak Admin Console
- **URL**: http://localhost:8180/admin
- **Username**: `admin`
- **Password**: `admin`

### Pre-configured Realm
- **Realm**: `fess`
- **Display Name**: Fess Test Realm

## Pre-configured Users

| Username | Password | Email | Role | Department |
|----------|----------|-------|------|------------|
| testuser | password123 | testuser@example.com | user | Engineering |
| admin | admin123 | admin@example.com | admin | - |
| 田中太郎 | password123 | tanaka@example.jp | user | 営業部 |

## Pre-configured Clients

### 1. OpenID Connect Client

- **Client ID**: `fess-client`
- **Client Secret**: `fess-secret-key-12345`
- **Protocol**: OpenID Connect
- **Access Type**: Confidential
- **Valid Redirect URIs**:
  - `http://localhost:8080/*`
  - `http://localhost/*`

### 2. SAML 2.0 Client

- **Client ID**: `fess-saml-client`
- **Protocol**: SAML 2.0
- **Valid Redirect URIs**: `http://localhost:8080/*`
- **Signature Algorithm**: RSA_SHA256

## OpenID Connect Endpoints

### Discovery Document
```
http://localhost:8180/realms/fess/.well-known/openid-configuration
```

### Key Endpoints
- **Authorization**: `http://localhost:8180/realms/fess/protocol/openid-connect/auth`
- **Token**: `http://localhost:8180/realms/fess/protocol/openid-connect/token`
- **UserInfo**: `http://localhost:8180/realms/fess/protocol/openid-connect/userinfo`
- **Logout**: `http://localhost:8180/realms/fess/protocol/openid-connect/logout`
- **JWKS**: `http://localhost:8180/realms/fess/protocol/openid-connect/certs`

## SAML 2.0 Endpoints

### Metadata
```
http://localhost:8180/realms/fess/protocol/saml/descriptor
```

### Key Endpoints
- **SSO Service**: `http://localhost:8180/realms/fess/protocol/saml`
- **Logout Service**: `http://localhost:8180/realms/fess/protocol/saml`

## Testing Authentication

### Test OpenID Connect Flow

```bash
# Get access token (Resource Owner Password Credentials Grant)
curl -X POST http://localhost:8180/realms/fess/protocol/openid-connect/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=fess-client" \
  -d "client_secret=fess-secret-key-12345" \
  -d "grant_type=password" \
  -d "username=testuser" \
  -d "password=password123"

# Get user info with access token
curl http://localhost:8180/realms/fess/protocol/openid-connect/userinfo \
  -H "Authorization: Bearer <access_token>"
```

### Test with Japanese User

```bash
# Authenticate as Japanese user
curl -X POST http://localhost:8180/realms/fess/protocol/openid-connect/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=fess-client" \
  -d "client_secret=fess-secret-key-12345" \
  -d "grant_type=password" \
  -d "username=田中太郎" \
  -d "password=password123"
```

## Fess Configuration

### For OpenID Connect Crawling

Create a crawler configuration in Fess:

1. **URL Pattern**: `http://your-protected-app/*`
2. **Authentication**: OpenID Connect
3. **Configuration**:
   - **Discovery URL**: `http://localhost:8180/realms/fess/.well-known/openid-configuration`
   - **Client ID**: `fess-client`
   - **Client Secret**: `fess-secret-key-12345`
   - **Scope**: `openid profile email`

### For SAML Crawling

Configure SAML authentication:

1. **Metadata URL**: `http://localhost:8180/realms/fess/protocol/saml/descriptor`
2. **Entity ID**: `fess-saml-client`

## Admin Operations

### Create New User via Admin Console

1. Access http://localhost:8180/admin
2. Select "fess" realm
3. Go to "Users" → "Add user"
4. Fill in user details and save
5. Go to "Credentials" tab and set password

### Create New Client

1. Go to "Clients" → "Create client"
2. Choose protocol (OpenID Connect or SAML)
3. Configure redirect URIs and settings
4. For OIDC: Note the client secret from "Credentials" tab

### Using Keycloak Admin CLI

```bash
# Execute admin CLI
docker exec -it keycloak /opt/keycloak/bin/kcadm.sh

# Login
docker exec keycloak /opt/keycloak/bin/kcadm.sh config credentials \
  --server http://localhost:8080 \
  --realm master \
  --user admin \
  --password admin

# List users in fess realm
docker exec keycloak /opt/keycloak/bin/kcadm.sh get users -r fess

# Create new user
docker exec keycloak /opt/keycloak/bin/kcadm.sh create users -r fess \
  -s username=newuser \
  -s enabled=true \
  -s email=newuser@example.com
```

## Features

### Supported Protocols
- OpenID Connect 1.0
- OAuth 2.0
- SAML 2.0
- LDAP / Active Directory federation

### Key Features
- Single Sign-On (SSO)
- Identity Brokering (social login)
- User Federation (LDAP/AD)
- Multi-factor Authentication (2FA)
- Fine-grained Authorization
- User Management UI
- Admin REST API
- Theme customization
- Event logging and auditing

### Grant Types Supported
- Authorization Code
- Implicit
- Resource Owner Password Credentials
- Client Credentials
- Refresh Token
- Device Authorization Grant

## Integration Examples

### Protecting a Web Application

```javascript
// Node.js example with Keycloak adapter
const session = require('express-session');
const Keycloak = require('keycloak-connect');

const memoryStore = new session.MemoryStore();
const keycloak = new Keycloak({ store: memoryStore }, {
  realm: 'fess',
  'auth-server-url': 'http://localhost:8180/',
  'ssl-required': 'none',
  resource: 'fess-client',
  credentials: {
    secret: 'fess-secret-key-12345'
  }
});

app.use(keycloak.middleware());
app.use('/protected', keycloak.protect(), protectedRoute);
```

### Python OIDC Integration

```python
from flask_oidc import OpenIDConnect
from flask import Flask

app = Flask(__name__)
app.config.update({
    'OIDC_CLIENT_SECRETS': {
        'web': {
            'issuer': 'http://localhost:8180/realms/fess',
            'auth_uri': 'http://localhost:8180/realms/fess/protocol/openid-connect/auth',
            'client_id': 'fess-client',
            'client_secret': 'fess-secret-key-12345',
            'redirect_uris': ['http://localhost:5000/oidc_callback'],
            'token_uri': 'http://localhost:8180/realms/fess/protocol/openid-connect/token',
            'userinfo_uri': 'http://localhost:8180/realms/fess/protocol/openid-connect/userinfo'
        }
    }
})
oidc = OpenIDConnect(app)

@app.route('/protected')
@oidc.require_login
def protected():
    return f"Hello, {oidc.user_getfield('email')}"
```

## Resource Requirements

- **Memory**: 1-2GB RAM recommended
- **CPU**: 1-2 cores
- **Startup Time**: 30-60 seconds
- **Disk Space**: ~500MB for images + data

## Troubleshooting

### Keycloak Won't Start

```bash
# Check logs
docker compose logs keycloak

# Check PostgreSQL is running
docker compose ps postgres

# Verify database connection
docker exec keycloak-postgres psql -U keycloak -d keycloak -c '\l'
```

### Cannot Access Admin Console

1. Verify port 8180 is not in use: `lsof -i :8180`
2. Check Keycloak logs: `docker compose logs keycloak`
3. Wait for full startup (can take 30-60 seconds)
4. Try accessing http://localhost:8180 first

### Realm Import Failed

```bash
# Check realm file syntax
cat data/realm/fess-realm.json | jq .

# Manual import via Admin Console
# 1. Access Admin Console
# 2. Create realm → Import → Select JSON file
```

### Token Validation Errors

- Ensure client secret matches configuration
- Check token expiration settings in realm
- Verify redirect URIs are correctly configured
- Check clock synchronization between services

## Security Notes

**Default Credentials**: This is a development environment with default credentials.
For production use:
- Change all default passwords
- Enable HTTPS
- Configure proper SSL certificates
- Review and harden security settings
- Enable rate limiting
- Set up proper session management
- Configure CORS policies carefully

## References

- [Keycloak Documentation](https://www.keycloak.org/documentation)
- [OpenID Connect Core Spec](https://openid.net/specs/openid-connect-core-1_0.html)
- [SAML 2.0 Spec](http://docs.oasis-open.org/security/saml/Post2.0/sstc-saml-tech-overview-2.0.html)
- [Keycloak Admin REST API](https://www.keycloak.org/docs-api/latest/rest-api/index.html)
