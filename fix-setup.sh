#!/bin/bash

echo "JSON Viewer - Fix Setup Script"
echo "============================="
echo "This script will reset your setup and start fresh."
echo ""

# Stop all containers
echo "Stopping all containers..."
docker compose down

# Clean up old files
echo "Cleaning up old Nginx files..."
rm -rf nginx/conf nginx/logs

# Set up Nginx from scratch
echo "Setting up Nginx from scratch..."
chmod +x setup-nginx.sh
./setup-nginx.sh

# Create environment files
echo "Creating environment files..."
if [ ! -f backend/.env ]; then
  cp backend/.env.example backend/.env
fi

if [ ! -f frontend/.env ]; then
  cp frontend/.env.example frontend/.env
fi

# Rebuild and start containers
echo "Rebuilding and starting containers..."
docker compose build --no-cache
docker compose up -d

echo ""
echo "Fix completed! JSON Viewer should now be running at: http://localhost"
echo "Check the logs with: docker compose logs -f"
