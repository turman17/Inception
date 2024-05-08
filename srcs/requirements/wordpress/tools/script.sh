#!/bin/bash

cd /var/www/html/

if [ ! -f /var/www/html/wp-config.php ]; then
	wget https://wordpress.org/latest.tar.gz
	tar xfz latest.tar.gz
	rm -f latest.tar.gz

	cp wordpress/wp-config-sample.php wordpress/wp-config.php

	sed -i "s/database_name_here/"$DB"/g" wordpress/wp-config.php
	sed -i "s/username_here/"$MYSQL_MANAGER"/g" wordpress/wp-config.php
	sed -i "s/password_here/"$MYSQL_MANAGER_PASSWORD"/g" wordpress/wp-config.php
	sed -i "s/localhost/"$DB_HOSTNAME"/g" wordpress/wp-config.php

	rm wordpress/wp-config-sample.php
	
	mv wordpress/* .
	rm -rf wordpress

	wp core install --allow-root --url=tlouro-c.42.fr --title=TomsWebsite \
	--admin_user=$WP_ADMIN \
	--admin_password=$WP_ADMIN_PASSWORD \
	--admin_email=$WP_ADMIN_EMAIL --skip-email
	wp user create $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD --allow-root;
fi

exec "$@"