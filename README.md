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

## Production Deployment with Custom Domain and SSL

The application includes an Nginx reverse proxy that can be configured to use a custom domain name and SSL certificates.

### Setting Up a Custom Domain

1. Run the SSL setup script, replacing `example.com` with your domain:

```bash
chmod +x setup-ssl.sh
./setup-ssl.sh example.com
```

2. This script will:
   - Configure the Nginx settings for your domain
   - Offer to generate self-signed certificates for development/testing
   - Provide instructions for installing real SSL certificates

3. For production, obtain proper SSL certificates (e.g., from Let's Encrypt) and place them in:
   - Certificate chain: `nginx/ssl/example.com.fullchain.pem`
   - Private key: `nginx/ssl/example.com.privkey.pem`

4. Restart the application:

```bash
./restart.sh
```

### Manual Configuration

If you prefer to configure SSL manually:

1. Edit the Nginx environment file at `nginx/.env`:
   ```
   SERVER_NAME=your-domain.com
   ENABLE_SSL=true
   SSL_CERT_FILE=your-domain.com.fullchain.pem
   SSL_KEY_FILE=your-domain.com.privkey.pem
   ```

2. Place your SSL certificates in the `nginx/ssl` directory:
   - Certificate chain: `nginx/ssl/your-domain.com.fullchain.pem`
   - Private key: `nginx/ssl/your-domain.com.privkey.pem`

3. Restart the application:
   ```bash
   ./restart.sh
   ```

### Accessing the Application

- With SSL enabled: `https://your-domain.com`
- Without SSL: `http://your-domain.com`

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

#### Nginx Connection Issues

If you see errors like `host not found in upstream "backend"` or `host not found in upstream "frontend"`:

1. Restart the containers:
   ```bash
   ./restart.sh
   ```

2. Make sure all scripts are executable:
   ```bash
   chmod +x start.sh restart.sh setup-ssl.sh nginx/docker-entrypoint.sh nginx/wait-for-it.sh
   ```

3. Check the status of all containers:
   ```bash
   docker-compose ps
   ```

4. If any container is not running, check its logs:
   ```bash
   docker-compose logs nginx
   docker-compose logs backend
   docker-compose logs frontend
   ```

5. You can manually test if services are reachable within the Docker network:
   ```bash
   docker exec -it json-viewer-nginx sh -c "ping backend"
   docker exec -it json-viewer-nginx sh -c "ping frontend"
   ```

#### SSL Certificate Issues

If you're having SSL certificate problems:

1. Check if your certificate files exist and have proper permissions:
   ```bash
   ls -la nginx/ssl/
   ```

2. For development, you can generate self-signed certificates:
   ```bash
   ./setup-ssl.sh yourdomain.com
   ```
   And answer 'y' when asked to generate self-signed certificates.

3. For production, make sure your certificate files are correctly named according to your `nginx/.env` file.

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
