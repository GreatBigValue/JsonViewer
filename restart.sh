#!/bin/bash

# Make sure necessary directories exist
mkdir -p nginx/ssl nginx/logs nginx/conf

# Stop any running containers
echo "Stopping existing containers..."
docker compose down

# Start containers
echo "Restarting containers..."
docker compose up -d

# Check if nginx container is running
NGINX_STATUS=$(docker compose ps | grep "json-viewer-nginx" | grep "Up" || echo "")
if [ -z "$NGINX_STATUS" ]; then
  echo "Warning: Nginx container is not running. Checking logs..."
  docker compose logs nginx

  echo "Trying to fix Nginx issues and restart..."
  # Ensure SSL is disabled for development mode
  cat > nginx/.env << EOF
# Server domain name
SERVER_NAME=localhost

# SSL Configuration - Disabled for development
ENABLE_SSL=false
SSL_CERT_FILE=fullchain.pem
SSL_KEY_FILE=privkey.pem
EOF

  # Restart and wait
  docker compose up -d
  sleep 3
fi

echo ""
echo "JSON Viewer is restarting!"

# Determine the access URL based on Nginx configuration
if [ -f nginx/.env ]; then
  source nginx/.env
  if [ "$ENABLE_SSL" = "true" ]; then
    PROTOCOL="https"
  else
    PROTOCOL="http"
  fi
  echo "- Application URL: $PROTOCOL://$SERVER_NAME"
else
  echo "- Application URL: http://localhost"
fi

echo "- PostgreSQL: localhost:5555"
echo ""
echo "To view logs: docker compose logs -f"
echo "To view frontend logs: docker compose logs -f frontend"
echo "To view nginx logs: docker compose logs -f nginx"
