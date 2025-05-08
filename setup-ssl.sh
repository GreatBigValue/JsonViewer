#!/bin/bash

echo "JSON Viewer - SSL Certificate Installation Script"
echo "================================================"
echo ""

# Check if domain is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <domain_name>"
    echo "Example: $0 jsonviewer.example.com"
    exit 1
fi

DOMAIN=$1
echo "Setting up SSL for domain: $DOMAIN"

# Create directories
mkdir -p nginx/ssl
mkdir -p nginx/logs

# Update Nginx environment file
cat > nginx/.env << EOF
# Server domain name
SERVER_NAME=$DOMAIN

# SSL Configuration
ENABLE_SSL=true
SSL_CERT_FILE=$DOMAIN.fullchain.pem
SSL_KEY_FILE=$DOMAIN.privkey.pem
EOF

echo "Updated nginx/.env file with domain: $DOMAIN"
echo ""

# Instructions for installing certificates
echo "Instructions for installing SSL certificates:"
echo "============================================="
echo "1. Obtain SSL certificates for $DOMAIN (e.g. using Let's Encrypt)"
echo "2. Copy your SSL certificate files to the nginx/ssl directory:"
echo ""
echo "   - Copy your certificate chain to: nginx/ssl/$DOMAIN.fullchain.pem"
echo "   - Copy your private key to: nginx/ssl/$DOMAIN.privkey.pem"
echo ""
echo "3. Restart the application:"
echo ""
echo "   ./restart.sh"
echo ""
echo "If you don't have certificates yet, the application will generate self-signed"
echo "certificates, but these will show a security warning in browsers."
echo ""

# Ask if user wants to generate self-signed certificates for development
read -p "Do you want to generate self-signed certificates for development? (y/n): " ANSWER
if [[ "$ANSWER" == "y" || "$ANSWER" == "Y" ]]; then
    echo "Generating self-signed certificates for $DOMAIN..."

    # Generate self-signed certificate
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "nginx/ssl/$DOMAIN.privkey.pem" \
        -out "nginx/ssl/$DOMAIN.fullchain.pem" \
        -subj "/CN=$DOMAIN" \
        -addext "subjectAltName=DNS:$DOMAIN,DNS:www.$DOMAIN"

    echo "Self-signed certificates generated successfully!"
    echo ""
    echo "WARNING: These are self-signed certificates for development only."
    echo "Browsers will display a security warning when using these certificates."
    echo ""
fi

echo "SSL setup completed for $DOMAIN"
echo "Now you can restart the application with: ./restart.sh"
