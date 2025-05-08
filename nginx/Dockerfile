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
