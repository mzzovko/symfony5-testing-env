FROM php:7.4.2-fpm

# Container dependencies
# unzip is needed for composer to be able to unzip some dependencies
RUN apt-get update && apt-get install -y \
    unzip

# PHP dependencies
RUN docker-php-ext-install pdo pdo_mysql

# PHP ecosystem dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && composer --version

# Configuration
RUN mkdir /var/www/symfony

RUN useradd -m symfony
RUN usermod -a -G www-data symfony

USER symfony

WORKDIR /var/www/symfony

EXPOSE 9000
