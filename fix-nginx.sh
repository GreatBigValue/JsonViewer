#!/bin/bash

echo "JSON Viewer - Fix Nginx Script"
echo "============================="
echo "This script will fix the Nginx setup."
echo ""

# Stop the nginx container
echo "Stopping nginx container..."
docker compose.yml stop nginx

# Update nginx files
echo "Updating Nginx files..."
chmod +x setup-nginx.sh
./setup-nginx.sh

# Make sure .env file is properly set
cat > nginx/.env << 'EOF'
# Server domain name
SERVER_NAME=localhost

# SSL Configuration - Disabled for development
ENABLE_SSL=false
SSL_CERT_FILE=fullchain.pem
SSL_KEY_FILE=privkey.pem
EOF

# Rebuild and start the nginx container
echo "Rebuilding and starting nginx container..."
docker compose.yml build nginx
docker compose.yml up -d nginx

echo ""
echo "Nginx fix completed! Check the logs with: docker compose.yml logs -f nginx"
