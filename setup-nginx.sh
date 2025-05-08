#!/bin/bash

# Create nginx directory structure and configuration files

echo "Setting up Nginx directory structure..."

# Create directories
mkdir -p nginx/ssl nginx/logs nginx/conf

# Copy default.conf.template
cat > nginx/conf/default.conf.template << 'EOF'
# Default configuration that redirects to HTTPS
server {
    listen 80;
    listen [::]:80;

    # Get server name from environment variable
    server_name ${SERVER_NAME} localhost;

    # Use Docker's DNS resolver
    resolver 127.0.0.11 valid=30s;

    # For development environment without SSL
    location / {
        # Use variables for dynamic resolution of hostnames
        set $frontend_upstream "frontend:3000";

        # If SSL is disabled, proxy to frontend directly
        proxy_pass http://$frontend_upstream;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # WebSocket support
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        # Don't fail if upstream is not available immediately
        proxy_connect_timeout 5s;
        proxy_read_timeout 60s;
        proxy_send_timeout 60s;
        proxy_next_upstream error timeout http_502 http_503 http_504;
    }

    # API requests to the backend
    location /api {
        # Use variables for dynamic resolution of hostnames
        set $backend_upstream "backend:3001";

        # Remove /api prefix when forwarding to backend
        rewrite ^/api(/.*)$ $1 break;

        proxy_pass http://$backend_upstream;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Don't fail if upstream is not available immediately
        proxy_connect_timeout 5s;
        proxy_read_timeout 60s;
        proxy_send_timeout 60s;
        proxy_next_upstream error timeout http_502 http_503 http_504;
    }

    # Let's Encrypt verification
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
}

# SSL server configuration - only used if SSL is enabled
${SSL_SERVER_BLOCK}
EOF

# Copy ssl_server_block.template
cat > nginx/conf/ssl_server_block.template << 'EOF'
# Main HTTPS server configuration
server {
    listen 443 ssl;
    listen [::]:443 ssl;

    # Get server name from environment variable
    server_name ${SERVER_NAME} localhost;

    # Use Docker's DNS resolver
    resolver 127.0.0.11 valid=30s;

    # SSL configuration
    ssl_certificate /etc/nginx/ssl/${SSL_CERT_FILE};
    ssl_certificate_key /etc/nginx/ssl/${SSL_KEY_FILE};

    # SSL settings (secure defaults)
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256';
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:10m;
    ssl_session_tickets off;

    # HSTS (uncomment for production)
    # add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;

    # Proxy frontend requests
    location / {
        # Use variables for dynamic resolution of hostnames
        set $frontend_upstream "frontend:3000";

        proxy_pass http://$frontend_upstream;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # WebSocket support
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        # Don't fail if upstream is not available immediately
        proxy_connect_timeout 5s;
        proxy_read_timeout 60s;
        proxy_send_timeout 60s;
        proxy_next_upstream error timeout http_502 http_503 http_504;
    }

    # Proxy API requests to the backend
    location /api {
        # Use variables for dynamic resolution of hostnames
        set $backend_upstream "backend:3001";

        # Remove /api prefix when forwarding to backend
        rewrite ^/api(/.*)$ $1 break;

        proxy_pass http://$backend_upstream;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Don't fail if upstream is not available immediately
        proxy_connect_timeout 5s;
        proxy_read_timeout 60s;
        proxy_send_timeout 60s;
        proxy_next_upstream error timeout http_502 http_503 http_504;
    }

    # Error logs
    error_log /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
}
EOF

# Create Nginx Dockerfile
cat > nginx/Dockerfile << 'EOF'
FROM nginx:alpine

# Install openssl for SSL certificate generation
RUN apk add --no-cache openssl netcat-openbsd

# Create directories
RUN mkdir -p /etc/nginx/ssl /var/www/certbot

# Copy scripts
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY wait-for-it.sh /wait-for-it.sh

# Make scripts executable
RUN chmod +x /docker-entrypoint.sh /wait-for-it.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
EOF

# Copy entrypoint script
cat > nginx/docker-entrypoint.sh << 'EOF'
#!/bin/sh
set -e

# Default values
SERVER_NAME=${SERVER_NAME:-localhost}
ENABLE_SSL=${ENABLE_SSL:-false}
SSL_CERT_FILE=${SSL_CERT_FILE:-fullchain.pem}
SSL_KEY_FILE=${SSL_KEY_FILE:-privkey.pem}

echo "Configuring Nginx for server: $SERVER_NAME"
echo "SSL enabled: $ENABLE_SSL"

# Process templates
if [ "$ENABLE_SSL" = "true" ]; then
    echo "Using SSL configuration with certificate: $SSL_CERT_FILE"

    # Check if SSL certificates exist
    if [ ! -f "/etc/nginx/ssl/$SSL_CERT_FILE" ] || [ ! -f "/etc/nginx/ssl/$SSL_KEY_FILE" ]; then
        echo "WARNING: SSL certificate files not found. Using self-signed certificates."

        # Create directory for SSL certificates if it doesn't exist
        mkdir -p /etc/nginx/ssl

        # Generate self-signed certificate
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout /etc/nginx/ssl/$SSL_KEY_FILE \
            -out /etc/nginx/ssl/$SSL_CERT_FILE \
            -subj "/CN=$SERVER_NAME"

        echo "Self-signed certificates generated."
    fi

    # Process SSL server block template
    SSL_SERVER_BLOCK=$(cat /etc/nginx/conf.d/ssl_server_block.template | envsubst '${SERVER_NAME},${SSL_CERT_FILE},${SSL_KEY_FILE}')
else
    echo "SSL disabled, using HTTP only configuration"
    SSL_SERVER_BLOCK=""
fi

# Apply templates
envsubst '${SERVER_NAME},${SSL_SERVER_BLOCK}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Print the resulting configuration for debugging
echo "Generated Nginx configuration:"
cat /etc/nginx/conf.d/default.conf

# Wait for backend and frontend to be available
echo "Waiting for backend to be available..."
# Sleep to give services time to start up
sleep 10

# Execute the main container command
exec "$@"
EOF

# Create wait-for-it script
cat > nginx/wait-for-it.sh << 'EOF'
#!/bin/sh

# Simple wait-for-it script (ash shell compatible)
set -e

HOST=$1
PORT=$2
TIMEOUT=${3:-30}
COMMAND=${@:4}

echo "Waiting for $HOST:$PORT (timeout: $TIMEOUT seconds)..."

# Loop until timeout is reached
START_TIME=$(date +%s)
END_TIME=$((START_TIME + TIMEOUT))

while [ $(date +%s) -lt $END_TIME ]; do
  if nc -z $HOST $PORT > /dev/null 2>&1; then
    echo "Service $HOST:$PORT is available after $(($(date +%s) - START_TIME)) seconds"

    # Execute command if provided
    if [ ! -z "$COMMAND" ]; then
      echo "Executing command: $COMMAND"
      exec $COMMAND
    fi

    exit 0
  fi

  echo "Waiting for $HOST:$PORT..."
  sleep 2
done

echo "Timeout reached. $HOST:$PORT is not available after $TIMEOUT seconds"

# Execute command anyway if provided
if [ ! -z "$COMMAND" ]; then
  echo "Executing command anyway: $COMMAND"
  exec $COMMAND
fi

exit 0
EOF

# Create default nginx .env file (SSL disabled for dev)
cat > nginx/.env << 'EOF'
# Server domain name
SERVER_NAME=localhost

# SSL Configuration - Disabled for development
ENABLE_SSL=false
SSL_CERT_FILE=fullchain.pem
SSL_KEY_FILE=privkey.pem
EOF

# Make scripts executable
chmod +x nginx/docker-entrypoint.sh
chmod +x nginx/wait-for-it.sh

echo "Nginx setup completed!"
