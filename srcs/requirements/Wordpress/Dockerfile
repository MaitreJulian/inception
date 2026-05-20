FROM debian:buster

# Setup apt for archived Debian Buster
RUN echo "deb http://archive.debian.org/debian buster main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until && \
    apt update -y && \
    apt upgrade -y

RUN apt-get -y install wget
RUN apt-get install -y php7.3 php-fpm php-mysql mariadb-client
RUN wget https://fr.wordpress.org/wordpress-6.9.4-fr_FR.tar.gz -P /var/www
RUN cd /var/www && tar -xzf wordpress-6.9.4-fr_FR.tar.gz && rm wordpress-6.9.4-fr_FR.tar.gz
RUN chown -R root:root /var/www/wordpress

COPY conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf