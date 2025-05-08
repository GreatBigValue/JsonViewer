#!/bin/bash

# Stop any running containers
echo "Stopping existing containers..."
docker compose down

# Start containers without rebuilding
echo "Restarting containers..."
docker compose up -d

echo ""
echo "JSON Viewer is restarting!"
echo "- Frontend: http://localhost:3000"
echo "- Backend: http://localhost:3001"
echo "- PostgreSQL: localhost:5555"
echo ""
echo "To view logs: docker compose logs -f"
echo "To view frontend logs: docker compose logs -f frontend"
