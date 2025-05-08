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

# Build and start the containers
echo "Starting Docker containers..."
docker compose build --no-cache
docker compose up -d

echo ""
echo "JSON Viewer is starting!"
echo "- Frontend: http://localhost:3000"
echo "- Backend: http://localhost:3001"
echo "- PostgreSQL: localhost:5555"
echo ""
echo "To view logs: docker compose logs -f"
echo "To stop: docker compose down"
