# Authentik Test Environment

Authentik is a modern, flexible Identity Provider (IdP) supporting OpenID Connect, OAuth 2.0, SAML 2.0, and LDAP protocols.

## Services

- **Authentik Server**: Web interface and API server
- **Authentik Worker**: Background task processor
- **PostgreSQL**: Backend database
- **Redis**: Cache and message queue

## Quick Start

```bash
# Start services
docker compose up -d

# Check logs
docker compose logs -f server

# Stop services
docker compose down

# Remove all data
docker compose down -v
```

## Access Information

### Initial Setup

On first startup, Authentik will prompt you to create an admin user:

1. Access http://localhost:9443/if/flow/initial-setup/
2. Create admin account:
   - **Email**: admin@example.com
   - **Username**: admin
   - **Password**: (your choice, e.g., admin123)

### Admin Interface

- **URL**: http://localhost:9443/if/admin/
- **Username**: admin
- **Password**: (set during initial setup)

### User Interface

- **URL**: http://localhost:9443/

## Creating Test Environment

### 1. Create a Provider (OpenID Connect)

1. Go to **Applications** → **Providers** → **Create**
2. Select **OAuth2/OpenID Provider**
3. Configure:
   - **Name**: Fess OIDC Provider
   - **Authorization flow**: explicit (Authorization Code)
   - **Client ID**: fess-client
   - **Client Secret**: fess-secret-key-12345
   - **Redirect URIs**: `http://localhost:8080/*`
   - **Signing Key**: Auto-generated

### 2. Create a Provider (SAML)

1. Go to **Applications** → **Providers** → **Create**
2. Select **SAML Provider**
3. Configure:
   - **Name**: Fess SAML Provider
   - **ACS URL**: `http://localhost:8080/saml/acs`
   - **Issuer**: fess-saml
   - **Service Provider Binding**: Post
   - **Audience**: `http://localhost:8080/`

### 3. Create an Application

1. Go to **Applications** → **Applications** → **Create**
2. Configure:
   - **Name**: Fess Test Application
   - **Slug**: fess-test
   - **Provider**: (select created provider)
   - **Launch URL**: `http://localhost:8080`

### 4. Create Test Users

1. Go to **Directory** → **Users** → **Create**
2. Example users:
   - **Username**: testuser, **Email**: testuser@example.com, **Password**: password123
   - **Username**: tanaka, **Name**: 田中太郎, **Email**: tanaka@example.jp, **Password**: password123

### 5. Create Groups (Optional)

1. Go to **Directory** → **Groups** → **Create**
2. Example groups:
   - developers
   - administrators
   -営業部

## OpenID Connect Configuration

### Discovery Endpoint

```
http://localhost:9443/application/o/fess-test/.well-known/openid-configuration
```

### Key Endpoints

- **Authorization**: `http://localhost:9443/application/o/authorize/`
- **Token**: `http://localhost:9443/application/o/token/`
- **UserInfo**: `http://localhost:9443/application/o/userinfo/`
- **Logout**: `http://localhost:9443/application/o/fess-test/end-session/`
- **JWKS**: `http://localhost:9443/application/o/fess-test/jwks/`

## SAML 2.0 Configuration

### Metadata Endpoint

```
http://localhost:9443/application/saml/fess-test/metadata/
```

### Key Endpoints

- **SSO (Redirect)**: `http://localhost:9443/application/saml/fess-test/sso/redirect/`
- **SSO (POST)**: `http://localhost:9443/application/saml/fess-test/sso/post/`
- **SLO (Redirect)**: `http://localhost:9443/application/saml/fess-test/slo/redirect/`
- **SLO (POST)**: `http://localhost:9443/application/saml/fess-test/slo/post/`

## Testing Authentication

### Test OpenID Connect

```bash
# Get access token (Authorization Code Flow - step 1: get authorization code)
# Visit in browser:
# http://localhost:9443/application/o/authorize/?client_id=fess-client&redirect_uri=http://localhost:8080/callback&response_type=code&scope=openid%20email%20profile

# Step 2: Exchange code for token
curl -X POST http://localhost:9443/application/o/token/ \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=authorization_code" \
  -d "client_id=fess-client" \
  -d "client_secret=fess-secret-key-12345" \
  -d "code=<authorization_code>" \
  -d "redirect_uri=http://localhost:8080/callback"

# Get user info
curl http://localhost:9443/application/o/userinfo/ \
  -H "Authorization: Bearer <access_token>"
```

### Test with Password Grant (if enabled)

```bash
curl -X POST http://localhost:9443/application/o/token/ \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password" \
  -d "client_id=fess-client" \
  -d "client_secret=fess-secret-key-12345" \
  -d "username=testuser" \
  -d "password=password123" \
  -d "scope=openid email profile"
```

## Fess Configuration

### For OpenID Connect Crawling

1. **URL Pattern**: `http://your-protected-app/*`
2. **Authentication**: OpenID Connect
3. **Configuration**:
   - **Discovery URL**: `http://localhost:9443/application/o/fess-test/.well-known/openid-configuration`
   - **Client ID**: `fess-client`
   - **Client Secret**: `fess-secret-key-12345`
   - **Scope**: `openid profile email`

### For SAML Crawling

1. **Metadata URL**: `http://localhost:9443/application/saml/fess-test/metadata/`
2. **Entity ID**: `fess-saml`

## Admin Operations

### Using Admin REST API

```bash
# Get API token (login first via web UI, then go to Admin Interface → Tokens)
# Or use username/password with API

# List users
curl http://localhost:9443/api/v3/core/users/ \
  -H "Authorization: Bearer <api_token>"

# Create user
curl -X POST http://localhost:9443/api/v3/core/users/ \
  -H "Authorization: Bearer <api_token>" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "newuser",
    "name": "New User",
    "email": "newuser@example.com",
    "is_active": true
  }'

# Set user password
curl -X POST http://localhost:9443/api/v3/core/users/<user_id>/set_password/ \
  -H "Authorization: Bearer <api_token>" \
  -H "Content-Type: application/json" \
  -d '{"password": "newpassword123"}'
```

### Managing via CLI

```bash
# Execute command in server container
docker exec -it authentik-server ak <command>

# Create superuser
docker exec -it authentik-server ak create_admin_group

# Import/export configuration
docker exec -it authentik-server ak export > authentik-config.yaml
docker exec -it authentik-server ak import < authentik-config.yaml

# Check system status
docker exec -it authentik-server ak check
```

## Features

### Supported Protocols
- OpenID Connect 1.0
- OAuth 2.0
- SAML 2.0
- LDAP (outpost required)
- Proxy Provider (forward auth)

### Key Features
- **Flows**: Customizable authentication/authorization flows
- **Policies**: Fine-grained access control
- **Property Mappings**: User attribute mapping
- **Events**: Comprehensive audit logging
- **Multi-tenancy**: Multiple applications/providers
- **MFA**: TOTP, WebAuthn, Duo, SMS
- **User Self-Service**: Password reset, profile editing
- **Social Login**: Google, GitHub, Microsoft, etc.
- **LDAP Outpost**: Act as LDAP provider
- **Proxy Outpost**: Forward authentication for apps

### Authentication Methods
- Password
- TOTP (Time-based OTP)
- Static tokens
- WebAuthn (FIDO2)
- Duo Push
- SMS
- Email verification

## Integration Examples

### Python OIDC Integration

```python
from authlib.integrations.flask_client import OAuth
from flask import Flask, redirect, url_for, session

app = Flask(__name__)
app.secret_key = 'random-secret-key'

oauth = OAuth(app)
authentik = oauth.register(
    name='authentik',
    client_id='fess-client',
    client_secret='fess-secret-key-12345',
    server_metadata_url='http://localhost:9443/application/o/fess-test/.well-known/openid-configuration',
    client_kwargs={
        'scope': 'openid email profile'
    }
)

@app.route('/login')
def login():
    redirect_uri = url_for('authorize', _external=True)
    return authentik.authorize_redirect(redirect_uri)

@app.route('/authorize')
def authorize():
    token = authentik.authorize_access_token()
    user = token['userinfo']
    session['user'] = user
    return redirect('/')
```

### SAML with Python

```python
from onelogin.saml2.auth import OneLogin_Saml2_Auth

saml_settings = {
    'sp': {
        'entityId': 'fess-saml',
        'assertionConsumerService': {
            'url': 'http://localhost:8080/saml/acs',
            'binding': 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST'
        }
    },
    'idp': {
        'entityId': 'http://localhost:9443/application/saml/fess-test/metadata/',
        'singleSignOnService': {
            'url': 'http://localhost:9443/application/saml/fess-test/sso/post/',
            'binding': 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST'
        },
        'x509cert': '<get from metadata>'
    }
}

auth = OneLogin_Saml2_Auth(request_data, saml_settings)
auth.login()
```

## Flow Customization

### Creating Custom Authentication Flow

1. Go to **Flows & Stages** → **Flows** → **Create**
2. Configure flow stages:
   - Identification (username/email)
   - Password
   - MFA (optional)
   - User Write
   - Login
3. Set flow designation (e.g., Authentication)
4. Assign to application

### Creating Custom Enrollment Flow

1. Create flow with stages:
   - User Write (create user)
   - Prompt (collect user data)
   - Email verification
   - Consent
2. Enable user enrollment in application settings

## Policy Examples

### IP-based Access Control

1. Go to **Policies** → **Create** → **Expression Policy**
2. Expression:
```python
return request.context['http_request'].META.get('REMOTE_ADDR') in ['192.168.1.0/24']
```

### Group-based Access

```python
return user.group_set.filter(name='administrators').exists()
```

### Time-based Access

```python
from datetime import datetime
now = datetime.now()
return now.hour >= 9 and now.hour < 17  # 9 AM - 5 PM
```

## Resource Requirements

- **Memory**: 1-2GB RAM recommended
- **CPU**: 2 cores recommended
- **Startup Time**: 45-90 seconds
- **Disk Space**: ~800MB for images + data

## Troubleshooting

### Server Won't Start

```bash
# Check logs
docker compose logs server worker

# Check dependencies
docker compose ps

# Verify database
docker exec authentik-postgres psql -U authentik -d authentik -c '\l'

# Check Redis
docker exec authentik-redis redis-cli ping
```

### Initial Setup Page Not Loading

1. Wait for full startup (can take 60-90 seconds)
2. Check logs: `docker compose logs -f server`
3. Verify port 9443 is accessible
4. Try accessing http://localhost:9443/if/admin/ directly

### Authentication Errors

```bash
# Check worker logs
docker compose logs worker

# Verify secret key matches between server and worker
docker compose config | grep AUTHENTIK_SECRET_KEY

# Check event logs in Admin Interface → System → Events
```

### Provider Configuration Issues

1. Verify redirect URIs match exactly
2. Check provider is assigned to application
3. Ensure signing key is configured for SAML
4. Review flow bindings in application settings

## Security Notes

**Development Environment**: This configuration uses default secrets and HTTP.
For production:
- Generate unique `AUTHENTIK_SECRET_KEY` (min 50 chars)
- Enable HTTPS with valid certificates
- Use strong database passwords
- Configure proper CORS settings
- Enable rate limiting
- Set up email notifications
- Review and configure policies
- Enable MFA for administrators
- Regular backup of database

## Advanced Configuration

### Enable LDAP Outpost

1. Go to **Outposts** → **Create**
2. Type: LDAP
3. Configure bind address (port 389/636)
4. Assign applications

### Configure Social Login

1. Go to **System** → **Sources** → **Create**
2. Select provider (Google, GitHub, etc.)
3. Enter OAuth credentials
4. Add to authentication flow

### Set Up Email Notifications

Edit compose.yaml and add:
```yaml
environment:
  AUTHENTIK_EMAIL__HOST: smtp.example.com
  AUTHENTIK_EMAIL__PORT: 587
  AUTHENTIK_EMAIL__USERNAME: smtp-user
  AUTHENTIK_EMAIL__PASSWORD: smtp-password
  AUTHENTIK_EMAIL__USE_TLS: "true"
  AUTHENTIK_EMAIL__FROM: authentik@example.com
```

## References

- [Authentik Documentation](https://goauthentik.io/docs/)
- [Authentik API Reference](https://goauthentik.io/api/)
- [Flow Examples](https://goauthentik.io/docs/flow/examples/)
- [Integration Guide](https://goauthentik.io/integrations/)
- [Expression Policies](https://goauthentik.io/docs/policies/expression/)
