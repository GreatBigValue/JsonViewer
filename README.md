# JSON Hierarchical Viewer

A full-stack application for parsing and viewing JSON in a hierarchical tree structure, allowing you to easily visualize and explore complex JSON data.

## Features

- Parse and validate JSON input
- Display JSON in a collapsible hierarchical tree view
- Save JSON documents to the database
- View and manage saved JSON documents
- Dark/Light theme support

## Tech Stack

- **Backend:** NestJS with TypeScript
- **Frontend:** NextJS with TypeScript and Hero UI
- **Database:** PostgreSQL 17.4
- **Runtime:** Bun (oven/bun:latest)
- **Containerization:** Docker & Docker Compose

## Project Structure

```
project-root/
├── backend/                 # NestJS application
│   ├── src/
│   │   ├── main.ts          # Application entry point
│   │   ├── app.module.ts    # Main application module
│   │   ├── app.controller.ts
│   │   ├── app.service.ts
│   │   └── json/           # JSON module
│   │       ├── json.module.ts
│   │       ├── json.controller.ts
│   │       ├── json.service.ts
│   │       ├── entities/
│   │       │   └── json.entity.ts
│   │       └── dto/
│   │           └── create-json.dto.ts
│   ├── Dockerfile
│   └── package.json
├── frontend/                # NextJS application
│   ├── src/
│   │   ├── app/
│   │   │   ├── page.tsx     # Home page
│   │   │   ├── layout.tsx
│   │   │   └── saved/      # Saved JSON page
│   │   │       └── page.tsx
│   │   ├── components/
│   │   │   ├── JsonInput.tsx
│   │   │   ├── JsonViewer.tsx
│   │   │   ├── Navbar.tsx
│   │   │   └── ThemeSwitcher.tsx
│   │   └── services/
│   │       └── api.ts
│   ├── Dockerfile
│   └── package.json
├── docker-compose.yml
└── README.md
```

## Getting Started

### Prerequisites

- Docker and Docker Compose installed on your machine

### Setting Up Environment Variables

1. Copy the example environment files and customize them as needed:

```bash
# For the backend
cp backend/.env.example backend/.env

# For the frontend
cp frontend/.env.example frontend/.env
```

2. Adjust the environment variables in these files if needed:
   - Backend `.env`: 
     - `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_USER`, `DATABASE_PASSWORD`, `DATABASE_NAME`
     - `PORT`: The port on which the backend server will run
     - `CORS_ORIGINS`: Comma-separated list of allowed origins for CORS
   - Frontend `.env`:
     - `NEXT_PUBLIC_BACKEND_URL`: The URL to access the backend API

### Running the Application

1. Clone this repository
2. Navigate to the project directory
3. Make the start script executable and run it:

```bash
chmod +x start.sh
./start.sh
```

Alternatively, you can set up manually:
```bash
# Copy example environment files
cp backend/.env.example backend/.env
cp frontend/.env.example frontend/.env

# Build and start containers
docker-compose build
docker-compose up -d
```

4. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:3001
   - PostgreSQL Database: localhost:5555 (changed from default 5432)

### Troubleshooting

If you encounter build issues, try these steps:

1. Make sure Docker and Docker Compose are up to date
2. Clean Docker cache and unused volumes:
   ```bash
   docker system prune -a
   docker volume prune
   ```
3. Rebuild the containers with no cache:
   ```bash
   docker-compose build --no-cache
   docker-compose up -d
   ```
4. Check the logs for errors:
   ```bash
   docker-compose logs -f backend
   docker-compose logs -f frontend
   ```

## API Endpoints

- `GET /json` - Get all saved JSON documents
- `GET /json/:id` - Get a specific JSON document
- `POST /json` - Save a new JSON document
- `DELETE /json/:id` - Delete a JSON document

## Usage

1. **Parse JSON:**
   - Paste your JSON into the text area
   - Click "Parse JSON" to validate and visualize it
   - Click "Format JSON" to format the JSON with proper indentation

2. **View JSON Tree:**
   - Expand/collapse nodes by clicking on them
   - Different data types are color-coded for easy identification

3. **Save JSON:**
   - Optionally provide a name for your JSON document
   - Click "Save JSON" to store it in the database

4. **Manage Saved Documents:**
   - Navigate to the "Saved Documents" page
   - View your saved JSON documents
   - Select a document to view its contents
   - Delete documents as needed
