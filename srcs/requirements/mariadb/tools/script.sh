#!/bin/bash

# Check required variables
if [ -z "$MYSQL_ROOT_PASSWORD" ] || [ -z "$DB" ] || [ -z "$MYSQL_MANAGER" ] || [ -z "$MYSQL_MANAGER_PASSWORD" ]; then
  echo "Error: Environment variables not set."
  exit 1
fi

# Directory where the WordPress database should reside
wordpress_db_dir="/var/lib/mysql/$DB"

# Proceed if the directory does not exist
if [ ! -d "$wordpress_db_dir" ]; then
    # Start MariaDB service
    service mariadb start || { echo "Failed to start MariaDB"; exit 1; }

    # Wait until MariaDB is ready
    while ! mysqladmin ping --silent; do
        sleep 1
    done

    # Configure MariaDB
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<_EOF_
        SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$MYSQL_ROOT_PASSWORD');
        DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
        DROP DATABASE IF EXISTS test;
        DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
        CREATE DATABASE $DB;
        CREATE USER '$MYSQL_MANAGER'@'%' IDENTIFIED BY '$MYSQL_MANAGER_PASSWORD';
        GRANT ALL PRIVILEGES ON $DB.* TO '$MYSQL_MANAGER'@'%';
        FLUSH PRIVILEGES;
        exit
_EOF_

    # Stop the MariaDB service
    service mariadb stop || { echo "Failed to stop MariaDB"; exit 1; }
fi

# Execute passed commands
exec "$@"
