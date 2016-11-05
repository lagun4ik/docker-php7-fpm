FROM lagun4ik/php7-fpm

MAINTAINER ivan@lagunovsky.com

ENV TERM=xterm \
    PHP_MEMORY_LIMIT=256M \
    PHP_ERROR_REPORTING=E_ALL \
    PHP_DISPLAY_ERRORS=On \
    PHP_DISPLAY_STARTUP_ERRORS=On \
    PHP_POST_MAX_SIZE=20M \
    PHP_MAX_UPLOAD_FILESIZE=10M \
    PHP_MAX_FILE_UPLOADS=20 \
    PHP_DATE_TIMEZONE=Europe/Minsk \
    PHP_OPCACHE_ENABLE=1 \
    PHP_OPCACHE_ENABLE_CLI=0 \
    PHP_XDEBUG_REMOTE_AUTOSTART=Off \
    PHP_XDEBUG_REMOTE_ENABLE=Off \
    PHP_XDEBUG_REMOTE_HANDLER="dbgp" \
    PHP_XDEBUG_REMOTE_HOST="localhost" \
    PHP_XDEBUG_REMOTE_PORT=9001 \
    PHP_XDEBUG_REMOTE_MODE=req \
    PHP_XDEBUG_IDEKEY="PHPSTORM"

RUN apk add --update --no-cache git nano unzip php7-xdebug openssh

COPY ./conf/php.ini /etc/php7/php.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -OsSL https://phar.phpunit.de/phpunit.phar \
    && chmod +x phpunit.phar \
    && mv phpunit.phar /usr/local/bin/phpunit
