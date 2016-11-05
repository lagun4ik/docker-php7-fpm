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
    PHP_OPCACHE_ENABLE_CLI=1 \
    PHP_OPCACHE_MEMORY_CONSUMPTION=256 \
    PHP_OPCACHE_INTERNED_STRINGS_BUFFER=32 \
    PHP_OPCACHE_MAX_ACCELERATED_FILES=100000 \
    PHP_OPCACHE_USE_CWD=0 \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS=1 \
    PHP_OPCACHE_REVALIDATE_FREQ=1 \
    PHP_OPCACHE_ENABLE_FILE_OVERRIDE=1 \
    PHP_XDEBUG_REMOTE_AUTOSTART=Off \
    PHP_XDEBUG_REMOTE_ENABLE=Off \
    PHP_XDEBUG_REMOTE_HANDLER="dbgp" \
    PHP_XDEBUG_REMOTE_HOST="localhost" \
    PHP_XDEBUG_REMOTE_PORT=9001 \
    PHP_XDEBUG_REMOTE_MODE=req \
    PHP_XDEBUG_IDEKEY="PHPSTORM"

RUN apk add --update --no-cache git nano unzip php7-xdebug openssh less

COPY ./conf/php.ini /etc/php7/php.ini
COPY ./scripts/ /usr/bin/

RUN mkdir /usr/local/phar

RUN curl -OsSL https://getcomposer.org/composer.phar \
    && mv composer.phar /usr/local/phar

RUN curl -OsSL https://phar.phpunit.de/phpunit.phar \
    && mv phpunit.phar /usr/local/phar

