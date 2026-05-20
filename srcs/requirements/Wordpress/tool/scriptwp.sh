#!/bin/bash

# Attendre que MariaDB soit prêt
until mysqladmin ping -h mariadb --silent; do
    echo "En attente de MariaDB..."
    sleep 2
done

# Configurer wp-config.php si pas déjà fait
if [ ! -f /var/www/wordpress/wp-config.php ]; then
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

# Lancer php-fpm en avant-plan
exec php-fpm8.2 -F