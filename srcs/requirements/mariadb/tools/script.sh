#!/bin/bash

# Wait for MariaDB to be ready
for i in {1..30}; do
    if mysqladmin ping -u root --password="$MYSQL_ROOT_PASSWORD" --silent; then
        echo "MariaDB is up and running!"
        break
    fi
    sleep 1
done

echo "Hello world1"
mysql -u root --password="$MYSQL_ROOT_PASSWORD" <<_EOF_
SET PASSWORD FOR 'root'@'localhost' = '$MYSQL_ROOT_PASSWORD';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
_EOF_
echo "Hello world"

mysql -u root --password="$MYSQL_ROOT_PASSWORD" <<_EOF_
CREATE DATABASE IF NOT EXISTS $DB;
CREATE USER IF NOT EXISTS '$MYSQL_MANAGER'@'%' IDENTIFIED BY '$MYSQL_MANAGER_PASSWORD';
GRANT ALL PRIVILEGES ON $DB.* TO '$MYSQL_MANAGER'@'%';
FLUSH PRIVILEGES;
_EOF_
echo "Hello world2"

exec mysqld_safe
