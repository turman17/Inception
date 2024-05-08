FROM debian:bullseye

# Install necessary packages
RUN apt-get update && \
    apt-get install -y nginx openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create directories and adjust permissions
RUN mkdir -p /etc/nginx /var/lib/nginx/body /var/lib/nginx/fastcgi /var/cache/nginx /var/run/nginx && \
    chown -R www-data:www-data /var/lib/nginx /var/cache/nginx /var/run/nginx /etc/nginx

# Generate SSL certificates
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/cert.key -out /etc/nginx/cert.crt \
    -subj "/CN=yourdomain.com"

# Copy custom Nginx configuration
COPY ./tools/nginx.conf /etc/nginx/nginx.conf

# Set working directory
WORKDIR /etc/nginx

# Expose ports
EXPOSE 443

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]