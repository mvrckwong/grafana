# Grafana with Neon PostgreSQL Setup

This setup automatically configures Grafana with 3 external Neon PostgreSQL databases as data sources using provisioning.

## Prerequisites

1. **Neon Account**: Create accounts and databases at [neon.tech](https://neon.tech)
2. **Docker & Docker Compose**: Ensure you have Docker and Docker Compose installed
3. **Environment Variables**: You'll need connection details for your 3 Neon databases

## Quick Setup

### 1. Get Neon Database Connection Details

For each of your 3 Neon databases, you'll need:
- **Host**: Usually in format `your-project-name.neon.tech`
- **Database Name**: Usually `neondb` (default)
- **Username**: Your Neon username
- **Password**: Your Neon password
- **Port**: `5432` (default PostgreSQL port)

### 2. Create Environment File

Copy the template and fill in your actual Neon connection details:

```bash
cp neon-env-template.txt .env
```

Edit `.env` with your actual Neon database connection details:

```env
# Grafana Configuration
GRAFANA_PASSWORD=your_secure_admin_password
GRAFANA_USER=admin

# Neon PostgreSQL Database 1 (Production)
NEON_DB1_NAME=Neon-Production
NEON_DB1_HOST=ep-example-123456.us-east-1.aws.neon.tech
NEON_DB1_DATABASE=neondb
NEON_DB1_USER=your_username
NEON_DB1_PASSWORD=your_password

# Neon PostgreSQL Database 2 (Staging) 
NEON_DB2_NAME=Neon-Staging
NEON_DB2_HOST=ep-example-789012.us-east-1.aws.neon.tech
NEON_DB2_DATABASE=neondb
NEON_DB2_USER=your_username
NEON_DB2_PASSWORD=your_password

# Neon PostgreSQL Database 3 (Analytics)
NEON_DB3_NAME=Neon-Analytics
NEON_DB3_HOST=ep-example-345678.us-east-1.aws.neon.tech
NEON_DB3_DATABASE=neondb
NEON_DB3_USER=your_username
NEON_DB3_PASSWORD=your_password
```

### 3. Create Required Directories

```powershell
# Windows PowerShell
mkdir -p grafana/data, grafana/logs, grafana/plugins
```

```bash
# Linux/macOS
mkdir -p grafana/{data,logs,plugins}
```

### 4. Set Proper Permissions (Linux/macOS only)

```bash
# Set ownership to Grafana user (472:472)
sudo chown -R 472:472 grafana/
```

### 5. Start Grafana

```bash
docker compose -f compose.grafana.yml up -d
```

### 6. Access Grafana

1. Open your browser and go to: http://localhost:3000
2. Login with:
   - **Username**: admin (or your custom `GRAFANA_USER`)
   - **Password**: your_secure_admin_password (from `.env` file)

## Verify Data Sources

After logging into Grafana:

1. Go to **Administration** → **Data Sources**
2. You should see 3 PostgreSQL data sources automatically configured:
   - **Neon-Production** (default data source)
   - **Neon-Staging**
   - **Neon-Analytics**

3. Click on each data source and click **Test** to verify connections

## Configuration Details

### Data Source Features

Each Neon PostgreSQL data source is configured with:
- **SSL Mode**: `require` (Neon requires SSL connections)
- **Connection Pooling**: Optimized settings for each database
- **PostgreSQL Version**: 15 (adjust if your Neon databases use different versions)
- **Editable**: Users can modify data source settings in the UI

### Connection Pool Settings

- **Production DB**: 100 max connections, 25 idle connections
- **Staging DB**: 50 max connections, 15 idle connections  
- **Analytics DB**: 75 max connections, 20 idle connections

## Troubleshooting

### Connection Issues

1. **SSL Errors**: Ensure `sslmode` is set to `require` in the data source configuration
2. **Authentication Failed**: Double-check your Neon username and password
3. **Host Not Found**: Verify the Neon host URL is correct
4. **Timeout**: Check if your network can reach neon.tech (port 5432)

### Common Commands

```bash
# View Grafana logs
docker compose -f compose.grafana.yml logs -f grafana

# Restart Grafana
docker compose -f compose.grafana.yml restart grafana

# Stop everything
docker compose -f compose.grafana.yml down

# Update Grafana
docker compose -f compose.grafana.yml pull
docker compose -f compose.grafana.yml up -d
```

### Check Data Source Configuration

If data sources aren't appearing automatically:

1. Check the provisioning directory exists: `./grafana/provisioning/datasources/`
2. Verify the postgres.yml file is properly formatted
3. Check Grafana logs for provisioning errors
4. Ensure environment variables are loaded correctly

### Modify Data Sources

You can edit `grafana/provisioning/datasources/postgres.yml` to:
- Change data source names
- Adjust connection pool settings
- Add more data sources
- Modify SSL settings

After changes, restart Grafana:
```bash
docker compose -f compose.grafana.yml restart grafana
```

## Security Best Practices

1. **Strong Passwords**: Use strong passwords for both Grafana admin and Neon databases
2. **Environment Variables**: Never commit `.env` file to version control
3. **Network Security**: Consider using Neon's IP allowlist feature
4. **Regular Updates**: Keep Grafana updated to the latest version
5. **Access Control**: Configure proper user roles and permissions in Grafana

## Advanced Configuration

### Using Neon for Grafana's Database

To store Grafana's own data in Neon instead of SQLite, uncomment and configure these variables in your `.env` file:

```env
GRAFANA_DB_TYPE=postgres
GRAFANA_DB_HOST=your-grafana-db-host.neon.tech:5432
GRAFANA_DB_NAME=grafana
GRAFANA_DB_USER=grafana_user
GRAFANA_DB_PASSWORD=grafana_db_password
```

### Adding More Data Sources

To add additional Neon databases, edit `grafana/provisioning/datasources/postgres.yml` and add new entries following the same pattern.

## Support

- **Grafana Documentation**: https://grafana.com/docs/
- **Neon Documentation**: https://neon.tech/docs/
- **PostgreSQL Data Source**: https://grafana.com/docs/grafana/latest/datasources/postgres/ 