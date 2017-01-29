FROM lagun4ik/php7-fpm

MAINTAINER ivan@lagunovsky.com

ENV TERM=xterm \
    PHP_OPCACHE_ENABLE_CLI=1 \
    PHP_XDEBUG_REMOTE_AUTOSTART=Off \
    PHP_XDEBUG_REMOTE_ENABLE=Off \
    PHP_XDEBUG_REMOTE_HANDLER="dbgp" \
    PHP_XDEBUG_REMOTE_HOST="localhost" \
    PHP_XDEBUG_REMOTE_PORT=9001 \
    PHP_XDEBUG_REMOTE_MODE=req \
    PHP_XDEBUG_IDEKEY="PHPSTORM"

RUN apk add --update --no-cache git nano unzip php7-xdebug openssh less
RUN rm /etc/php7/conf.d/xdebug.ini

COPY ./conf/xdebug.ini /etc/php7/conf.d/xdebug.ini
COPY ./scripts/ /usr/bin/

RUN mkdir /usr/local/phar

RUN curl -OsSL https://getcomposer.org/composer.phar \
    && mv composer.phar /usr/local/phar

RUN curl -OsSL https://phar.phpunit.de/phpunit.phar \
    && mv phpunit.phar /usr/local/phar

CMD ["/usr/sbin/php-fpm7", "-R", "-dzend_extension=xdebug.so"]
