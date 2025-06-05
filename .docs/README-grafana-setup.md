# Grafana Docker Compose Setup

## Improvements Made

### 🔒 Security Enhancements
- **Pinned Image Version**: Using `grafana/grafana:10.2.3` instead of `latest` for reproducible deployments
- **Enhanced Security Headers**: Added CSP, XSS protection, and content type options
- **User Restrictions**: Disabled sign-up, org creation, and anonymous access
- **Container Security**: Added `no-new-privileges` and running as grafana user (472:472)
- **Read-only Provisioning**: Mounted provisioning directory as read-only

### 🚀 Production Readiness
- **Resource Limits**: Set memory and CPU limits/reservations
- **Improved Health Checks**: Better retry logic and startup period
- **Logging Configuration**: Structured logging with rotation
- **Container Naming**: Added explicit container name for easier management

### 📊 Enhanced Functionality
- **Additional Plugins**: Added pie chart and world map plugins
- **External Database Support**: Configurable database backend
- **SMTP Configuration**: Email notification support
- **Custom Volumes**: Separate volumes for logs and plugins

### 🔧 Configuration Management
- **Environment Variables**: Extensive use of environment variables for flexibility
- **Labels**: Added Traefik and Watchtower labels for reverse proxy and auto-updates
- **Network Configuration**: Custom network with dedicated subnet

## Quick Start

1. **Create Required Directories**:
   ```bash
   mkdir -p grafana/{data,logs,plugins,provisioning/{dashboards,datasources,notifiers}}
   ```

2. **Set Proper Permissions**:
   ```bash
   # On Linux/macOS
   sudo chown -R 472:472 grafana/
   
   # On Windows (run as Administrator)
   icacls grafana /grant "Everyone:(OI)(CI)F" /T
   ```

3. **Create Environment File**:
   ```bash
   # Copy and customize your environment variables
   cat > .env << EOF
   GRAFANA_PASSWORD=your_secure_password_here
   GRAFANA_USER=admin
   GRAFANA_ROOT_URL=http://localhost:3000
   GRAFANA_DOMAIN=localhost
   GRAFANA_LOG_LEVEL=info
   GRAFANA_SMTP_ENABLED=false
   EOF
   ```

4. **Start Grafana**:
   ```bash
   docker compose -f compose.grafana.yml up -d
   ```

5. **Access Grafana**:
   - URL: http://localhost:3000
   - Username: admin (or your custom GRAFANA_USER)
   - Password: your_secure_password_here (or your custom GRAFANA_PASSWORD)

## Configuration Options

### Database Configuration
For production use, consider using an external database:
```env
GRAFANA_DB_TYPE=postgres
GRAFANA_DB_HOST=postgres:5432
GRAFANA_DB_NAME=grafana
GRAFANA_DB_USER=grafana
GRAFANA_DB_PASSWORD=your_db_password
```

### SMTP Configuration
To enable email notifications:
```env
GRAFANA_SMTP_ENABLED=true
GRAFANA_SMTP_HOST=smtp.gmail.com:587
GRAFANA_SMTP_USER=your_email@gmail.com
GRAFANA_SMTP_PASSWORD=your_app_password
GRAFANA_SMTP_FROM=grafana@yourdomain.com
```

### Reverse Proxy (Traefik)
The configuration includes Traefik labels. To use with Traefik:
```env
GRAFANA_DOMAIN=grafana.yourdomain.com
GRAFANA_ROOT_URL=https://grafana.yourdomain.com
```

## Monitoring and Maintenance

### Health Check
The health check endpoint is available at `/api/health` and runs every 30 seconds.

### Logs
- Container logs: `docker compose -f compose.grafana.yml logs -f grafana`
- Grafana logs: Check `./grafana/logs/` directory

### Backups
- **Data**: Backup `./grafana/data/` directory
- **Configuration**: Backup `./grafana/provisioning/` directory
- **Database**: If using external DB, backup the database

### Updates
With Watchtower labels enabled, the container will auto-update when new versions are available.

## Troubleshooting

### Permission Issues
```bash
# Fix permissions (Linux/macOS)
sudo chown -R 472:472 grafana/

# Check container logs
docker compose -f compose.grafana.yml logs grafana
```

### Plugin Installation Issues
If plugins fail to install, check the logs and ensure internet connectivity:
```bash
docker compose -f compose.grafana.yml exec grafana grafana-cli plugins list-remote
```

### Memory Issues
If Grafana runs out of memory, increase the limits in the compose file:
```yaml
deploy:
  resources:
    limits:
      memory: 2G  # Increase as needed
```

## Security Considerations

1. **Change Default Credentials**: Always change the default admin password
2. **Use HTTPS**: Configure reverse proxy with SSL/TLS
3. **Regular Updates**: Keep Grafana version updated
4. **Access Control**: Use proper authentication and authorization
5. **Network Security**: Restrict network access as appropriate

## Additional Plugins

To add more plugins, update the `GF_INSTALL_PLUGINS` environment variable:
```yaml
- GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource,grafana-piechart-panel,grafana-worldmap-panel,grafana-polystat-panel
``` 