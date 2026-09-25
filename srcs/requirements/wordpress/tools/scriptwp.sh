#!/bin/bash

# Attendre que MariaDB soit prêt
until mysqladmin ping -h mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
    echo "En attente de MariaDB..."
    sleep 2
done

# Configurer wp-config.php si pas déjà fait
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    if [ ! -f /var/www/wordpress/wp-load.php ]; then
        wget https://fr.wordpress.org/wordpress-6.9.4-fr_FR.tar.gz -P /tmp
        tar -xzf /tmp/wordpress-*.tar.gz -C /tmp
        cp -a /tmp/wordpress/. /var/www/wordpress/
    fi

    wp config create \
        --path=/var/www/wordpress \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb \
        --allow-root

    wp core install \
        --path=/var/www/wordpress \
        --url=$DOMAIN_NAME \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root

    # Créer un utilisateur supplémentaire (non admin)
    wp user create $WP_USER $WP_USER_EMAIL \
        --role=author \
        --user_pass=$WP_USER_PASSWORD \
        --path=/var/www/wordpress \
        --allow-root
fi

chown -R www-data:www-data /var/www/wordpress
# Lancer php-fpm en avant-plan
exec php-fpm8.2 -F