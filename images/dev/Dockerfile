ARG BUILD_VERSION

FROM lagun4ik/php7-fpm:${BUILD_VERSION}

MAINTAINER ivan@lagunovsky.com

USER root

ENV TERM=xterm \
    PHP_DISPLAY_ERRORS=1 \
    PHP_DISPLAY_STARTUP_ERRORS=1 \
    PHP_XDEBUG_REMOTE_AUTOSTART=Off \
    PHP_XDEBUG_REMOTE_ENABLE=Off \
    PHP_XDEBUG_REMOTE_HANDLER="dbgp" \
    PHP_XDEBUG_REMOTE_HOST="localhost" \
    PHP_XDEBUG_REMOTE_PORT=9001 \
    PHP_XDEBUG_REMOTE_MODE=req \
    PHP_XDEBUG_IDEKEY="PHP_IDE" \
    PHP_XDEBUG_PROFILER_AGGREGATE=0 \
    PHP_XDEBUG_PROFILER_APPEND=0 \
    PHP_XDEBUG_PROFILER_ENABLE=0 \
    PHP_XDEBUG_PROFILER_ENABLE_TRIGGER=0 \
    PHP_XDEBUG_PROFILER_ENABLE_TRIGGER_VALUE="" \
    PHP_XDEBUG_PROFILER_OUTPUT_DIR="/tmp" \
    PHP_XDEBUG_PROFILER_OUTPUT_NAME="cachegrind.out.%p"

ARG PHP_XDEBUG_VERSION

RUN apk add --update --no-cache sudo git nano unzip openssh htop php7-xdebug=${PHP_XDEBUG_VERSION}

COPY conf/xdebug.ini /etc/php7/conf.d/xdebug.ini
COPY bin /usr/bin/

RUN mkdir /usr/local/phar

RUN curl -OsSL https://getcomposer.org/composer.phar \
    && mv composer.phar /usr/local/phar

RUN curl -OsSL https://phar.phpunit.de/phpunit.phar \
    && mv phpunit.phar /usr/local/phar

RUN cd /usr/bin/ && chmod +x composer php phpunit

USER www-data

VOLUME ['/home/www-data/.composer']

CMD ["/usr/sbin/php-fpm7", "-dzend_extension=xdebug.so"]
