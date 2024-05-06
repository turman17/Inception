#!/bin/bash

# Define the WordPress base directory for clarity and reusability
WP_DIR="/var/www/html"

cd $WP_DIR

# Check if WordPress has not already been configured
if [ ! -f "$WP_DIR/wp-config.php" ]; then
    echo "Downloading WordPress..."
    wget -q https://wordpress.org/latest.tar.gz
    echo "Unpacking WordPress..."
    tar xfz latest.tar.gz
    rm -f latest.tar.gz

    echo "Configuring WordPress..."
    cp wordpress/wp-config-sample.php wordpress/wp-config.php

    # Update configuration settings with environment variables
    sed -i "s/database_name_here/$MYSQL_DATABASE/g" wordpress/wp-config.php
    sed -i "s/username_here/$MYSQL_USER/g" wordpress/wp-config.php
    sed -i "s/password_here/$MYSQL_PASSWORD/g" wordpress/wp-config.php
    sed -i "s/localhost/mariadb/g" wordpress/wp-config.php  # Assuming mariadb is the hostname in docker-compose

    rm wordpress/wp-config-sample.php
    
    # Move WordPress to the root of the web directory
    mv wordpress/* . && rm -rf wordpress

    echo "Installing WordPress..."
    wp core install --allow-root --url="tlouro-c.42.fr" --title="Tom's Website" \
        --admin_user="$WORDPRESS_USER" \
        --admin_password="$WORDPRESS_PASSWORD" \
        --admin_email="admin@example.com" --skip-email  # Update email as necessary
    
    echo "Creating additional user..."
    wp user create $WORDPRESS_USER "user@example.com" --user_pass=$WORDPRESS_PASSWORD --allow-root  # Update email as necessary
fi

exec "$@"
