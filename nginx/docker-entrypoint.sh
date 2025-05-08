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
