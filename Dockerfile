FROM php:7.4.2-fpm

# Container dependencies
# unzip is needed for composer to be able to unzip some dependencies
RUN apt-get update && apt-get install -y \
    unzip netcat git

# PHP dependencies
RUN docker-php-ext-install pdo pdo_mysql ext-sockets

# Add xdebug so we can get test coverage
RUN pecl install xdebug; \
    docker-php-ext-enable xdebug; \
    echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini;

# PHP ecosystem dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && composer --version

# Configuration
RUN mkdir /var/www/symfony

RUN useradd -m symfony
RUN usermod -a -G www-data symfony

USER symfony

WORKDIR /var/www/symfony

EXPOSE 9000
