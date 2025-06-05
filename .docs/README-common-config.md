# Common Environment Configuration Guide

This guide demonstrates how to create reusable Docker Compose configurations without hardcoded images, making them environment-agnostic.

## Approach 1: Using Extension Fields (x-) with Base Templates

Create a `compose.base.yml` file with common configurations:

```yaml
# Base configuration template
x-grafana-defaults: &grafana-defaults
  ports:
    - "3000:3000"
  volumes:
    - ./grafana/provisioning:/etc/grafana/provisioning:ro
    - ./grafana/data:/var/lib/grafana
    - ./grafana/logs:/var/log/grafana
    - ./grafana/plugins:/var/lib/grafana/plugins
  restart: unless-stopped
  env_file:
    - .env
  deploy:
    resources:
      limits:
        memory: 1G
        cpus: '0.5'
      reservations:
        memory: 512M
        cpus: '0.25'
  security_opt:
    - no-new-privileges:true
  read_only: false
  user: "472:472"
  healthcheck:
    test: ["CMD-SHELL", "wget --no-verbose --tries=1 --spider http://localhost:3000/api/health || exit 1"]
    interval: 30s
    timeout: 10s
    retries: 5
    start_period: 60s
  logging:
    driver: "json-file"
    options:
      max-size: "10m"
      max-file: "3"
  networks:
    - monitoring
    - default
```

## Approach 2: Environment-Specific Compose Files

### Production Environment
```yaml
# compose.prod.yml
name: grafana-production
services:
  grafana:
    <<: *grafana-defaults
    image: grafana/grafana:12.0.1
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_PASSWORD:-admin}
      - GF_SECURITY_ADMIN_USER=${GRAFANA_USER:-admin}
      - GF_SERVER_ROOT_URL=https://grafana.yourdomain.com
      - GF_SERVER_DOMAIN=grafana.yourdomain.com
      - GF_SECURITY_ALLOW_EMBEDDING=false
      # ... other production-specific vars
```

### Development Environment
```yaml
# compose.dev.yml
name: grafana-development
services:
  grafana:
    <<: *grafana-defaults
    image: grafana/grafana:latest
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=dev
      - GF_SECURITY_ADMIN_USER=dev
      - GF_SERVER_ROOT_URL=http://localhost:3000
      - GF_SERVER_DOMAIN=localhost
      - GF_USERS_ALLOW_SIGN_UP=true
      # ... other development-specific vars
```

## Approach 3: Using Multiple Compose Files

You can use Docker Compose's ability to merge multiple files:

```bash
# For production
docker-compose -f compose.base.yml -f compose.prod.yml up

# For development
docker-compose -f compose.base.yml -f compose.dev.yml up
```

## Approach 4: Environment Variables for Images

Create a single compose file that uses environment variables for images:

```yaml
services:
  grafana:
    image: ${GRAFANA_IMAGE:-grafana/grafana:12.0.1}
    # ... rest of configuration
```

Then use different `.env` files:

```bash
# .env.prod
GRAFANA_IMAGE=grafana/grafana:12.0.1

# .env.dev
GRAFANA_IMAGE=grafana/grafana:latest
```

## Benefits of This Approach

1. **Reusability**: Common configurations are defined once
2. **Environment Flexibility**: Easy to switch between different images/versions
3. **Maintainability**: Changes to common configs apply everywhere
4. **Security**: Environment-specific security settings
5. **Scalability**: Easy to add new environments

## Usage Examples

```bash
# Use production configuration
docker-compose -f compose.base.yml -f compose.prod.yml up -d

# Use development configuration
docker-compose -f compose.base.yml -f compose.dev.yml up -d

# Use with environment variables
GRAFANA_IMAGE=grafana/grafana:latest docker-compose up -d
```

This approach gives you maximum flexibility while maintaining clean, reusable configurations without hardcoded Docker images. 