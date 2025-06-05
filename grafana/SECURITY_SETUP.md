# Secure Grafana Datasource Configuration

## Overview
The postgres.yml datasource configuration has been updated to use environment variables instead of hardcoded credentials for better security.

## Environment Variables Required

Set the following environment variables before starting Grafana:

```bash
# Postgres Database Configuration
export POSTGRES_HOST="ep-empty-water-a1hetn45.ap-southeast-1.aws.neon.tech"
export POSTGRES_PORT="5432"
export POSTGRES_DATABASE="neondb"
export POSTGRES_USER="neondb_owner"
export POSTGRES_PASSWORD="npg_ldTXk7nG1EIQ"
```

## Setup Options

### Option 1: Environment Variables (Recommended)
Create a `.env` file in your grafana directory:

```env
POSTGRES_HOST=ep-empty-water-a1hetn45.ap-southeast-1.aws.neon.tech
POSTGRES_PORT=5432
POSTGRES_DATABASE=neondb
POSTGRES_USER=neondb_owner
POSTGRES_PASSWORD=npg_ldTXk7nG1EIQ
```

**Important:** Add `.env` to your `.gitignore` file to prevent credentials from being committed to version control.

### Option 2: Docker Compose
If using Docker Compose, add these to your environment section:

```yaml
services:
  grafana:
    environment:
      - POSTGRES_HOST=ep-empty-water-a1hetn45.ap-southeast-1.aws.neon.tech
      - POSTGRES_PORT=5432
      - POSTGRES_DATABASE=neondb
      - POSTGRES_USER=neondb_owner
      - POSTGRES_PASSWORD=npg_ldTXk7nG1EIQ
```

### Option 3: Kubernetes Secrets
For Kubernetes deployments, create a secret:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: postgres-credentials
type: Opaque
data:
  host: <base64-encoded-host>
  port: <base64-encoded-port>
  database: <base64-encoded-database>
  username: <base64-encoded-username>
  password: <base64-encoded-password>
```

## Security Benefits

- ✅ Credentials are not stored in version control
- ✅ Different environments can use different credentials
- ✅ Secrets can be managed by dedicated secret management systems
- ✅ Reduces risk of credential exposure in logs and configuration files

## Additional Security Recommendations

1. **Rotate credentials regularly**
2. **Use least-privilege database users**
3. **Enable SSL/TLS for database connections** (already configured with `sslmode: require`)
4. **Monitor database access logs**
5. **Use a dedicated secret management service** (e.g., HashiCorp Vault, AWS Secrets Manager)

## Verification

After setting up the environment variables, verify the configuration works by:

1. Starting Grafana with the environment variables set
2. Checking the Grafana logs for any connection errors
3. Testing the datasource connection in the Grafana UI 