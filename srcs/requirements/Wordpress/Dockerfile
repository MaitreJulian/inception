FROM debian:bookworm

RUN apt update -y && \
    apt upgrade -y && \
    apt-get install -y wget curl php8.2 php-fpm php-mysql mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Téléchargement et installation de WordPress
RUN wget https://fr.wordpress.org/wordpress-6.9.4-fr_FR.tar.gz -P /var/www && \
    cd /var/www && tar -xzf wordpress-6.9.4-fr_FR.tar.gz && rm wordpress-6.9.4-fr_FR.tar.gz

# Téléchargement et installation de WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN chown -R root:root /var/www/wordpress

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/scriptwp.sh .
RUN chmod +x scriptwp.sh
CMD ["./scriptwp.sh"]