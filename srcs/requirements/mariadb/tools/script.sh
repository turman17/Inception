#!/bin/bash

working_dir="/var/lib/mysql/$DB"

if [ ! -d "$working_dir" ]; then

service mariadb start

echo "Creating Working directory $working_dir"

mysql -u root <<_EOF_
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$MYSQL_ROOT_PASSWORD');
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
exit
_EOF_

mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<_EOF_
CREATE DATABASE $DB;
CREATE USER '$MYSQL_MANAGER'@'%' IDENTIFIED BY '$MYSQL_MANAGER_PASSWORD';
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON $DB.* TO '$MYSQL_MANAGER'@'%';
FLUSH PRIVILEGES;
exit
_EOF_

sleep 3

service mariadb stop

fi

exec "$@"
