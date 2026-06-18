#!/bin/sh

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar

./wp-cli.phar core download --allow-root
./wp-cli.phar config create --dbname=$MYSQL_DB_NAME --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb --allow-root
./wp-cli.phar core install --url=$DOMAIN_NAME --title=inception --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASS --admin_email=$WP_ADMIN_MAIL --allow-root
./wp-cli.phar user create $WP_USER $WP_USER_MAIL --role=author --user_pass=$WP_USER_PASS --allow-root
./wp-cli.phar user set-role 2 editor --allow-root

# Redis setup
./wp-cli.phar config set WP_REDIS_HOST redis --type=constant --allow-root
./wp-cli.phar config set WP_REDIS_PORT 6379 --raw --type=constant --allow-root
./wp-cli.phar plugin install redis-cache --activate --allow-root
./wp-cli.phar redis enable --allow-root

exec php-fpm8.2 -F