#!/bin/bash

# Ensure environment files exist
if [ ! -f backend/.env ]; then
  echo "Creating backend/.env from example..."
  cp backend/.env.example backend/.env
fi

if [ ! -f frontend/.env ]; then
  echo "Creating frontend/.env from example..."
  cp frontend/.env.example frontend/.env
fi

# Create nginx env file with SSL disabled
cat > nginx/.env << EOF
# Server domain name
SERVER_NAME=localhost

# SSL Configuration - Disabled for development
ENABLE_SSL=false
SSL_CERT_FILE=fullchain.pem
SSL_KEY_FILE=privkey.pem
EOF

# Make sure nginx is set up correctly
if [ ! -f nginx/docker-entrypoint.sh ] || [ ! -f nginx/conf/default.conf.template ]; then
  echo "Setting up Nginx files..."
  chmod +x setup-nginx.sh
  ./setup-nginx.sh
fi

# Build and start the containers
echo "Starting Docker containers in development mode..."
docker compose build
docker compose up -d

echo ""
echo "JSON Viewer is starting in development mode!"
echo "- Application URL: http://localhost"
echo "- PostgreSQL: localhost:5555"
echo ""
echo "To view logs: docker compose logs -f"
echo "To stop: docker compose down"
