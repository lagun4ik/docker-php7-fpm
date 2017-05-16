FROM alpine:3.5

MAINTAINER ivan@lagunovsky.com

ENV PHP_MEMORY_LIMIT=256M \
   PHP_ERROR_REPORTING=E_ALL \
   PHP_DISPLAY_ERRORS=0 \
   PHP_DISPLAY_STARTUP_ERRORS=0 \
   PHP_TRACK_ERRORS=0 \
   PHP_POST_MAX_SIZE=20M \
   PHP_MAX_UPLOAD_FILESIZE=10M \
   PHP_MAX_FILE_UPLOADS=20 \
   PHP_MAX_INPUT_TIME=60 \
   PHP_DATE_TIMEZONE=Europe/Minsk \
   PHP_VARIABLES_ORDER=EGPCS \
   PHP_REQUEST_ORDER=GP \
   PHP_LOG_ERRORS=0 \
   PHP_SESSION_SERIALIZE_HANDLER=php_binary \
   PHP_SESSION_SAVE_HANDLER=files \
   PHP_SESSION_SAVE_PATH=/tmp \
   PHP_SESSION_GC_PROBABILITY=1 \
   PHP_SESSION_GC_DIVISOR=10000 \
   PHP_OPCACHE_ENABLE=1 \
   PHP_OPCACHE_ENABLE_CLI=0 \
   PHP_OPCACHE_MEMORY_CONSUMPTION=128 \
   PHP_OPCACHE_INTERNED_STRINGS_BUFFER=32 \
   PHP_OPCACHE_MAX_ACCELERATED_FILES=10000 \
   PHP_OPCACHE_USE_CWD=1 \
   PHP_OPCACHE_VALIDATE_TIMESTAMPS=1 \
   PHP_OPCACHE_REVALIDATE_FREQ=2 \
   PHP_OPCACHE_ENABLE_FILE_OVERRIDE=0 \
   PHP_ZEND_ASSERTIONS=-1 \
   PHP_IGBINARY_COMPACT_STRINGS=1

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

RUN apk upgrade --update --no-cache && \
    apk add --update --no-cache \
    ca-certificates \
    curl \
    bash

RUN apk add --update --no-cache \
        php7-session=7.1.5-r0 \
        php7-mcrypt=7.1.5-r0 \
        php7-soap=7.1.5-r0 \
        php7-openssl=7.1.5-r0 \
        php7-gmp=7.1.5-r0 \
        php7-pdo_odbc=7.1.5-r0 \
        php7-json=7.1.5-r0 \
        php7-dom=7.1.5-r0 \
        php7-pdo=7.1.5-r0 \
        php7-zip=7.1.5-r0 \
        php7-mysqli=7.1.5-r0 \
        php7-sqlite3=7.1.5-r0 \
        php7-pdo_pgsql=7.1.5-r0 \
        php7-bcmath=7.1.5-r0 \
        php7-gd=7.1.5-r0 \
        php7-odbc=7.1.5-r0 \
        php7-pdo_mysql=7.1.5-r0 \
        php7-pdo_sqlite=7.1.5-r0 \
        php7-gettext=7.1.5-r0 \
        php7-xmlreader=7.1.5-r0 \
        php7-xmlwriter=7.1.5-r0 \
        php7-xmlrpc=7.1.5-r0 \
        php7-xml=7.1.5-r0 \
        php7-bz2=7.1.5-r0 \
        php7-iconv=7.1.5-r0 \
        php7-pdo_dblib=7.1.5-r0 \
        php7-curl=7.1.5-r0 \
        php7-ctype=7.1.5-r0 \
        php7-pcntl=7.1.5-r0 \
        php7-posix=7.1.5-r0 \
        php7-phar=7.1.5-r0 \
        php7-opcache=7.1.5-r0 \
        php7-mbstring=7.1.5-r0 \
        php7-zlib=7.1.5-r0 \
        php7-fileinfo=7.1.5-r0 \
        php7-fpm=7.1.5-r0 \
        php7=7.1.5-r0

RUN rm -rf /etc/php7/php.ini && \
    mkdir /var/www

RUN apk add --update --no-cache libmemcached rabbitmq-c

RUN apk add --update --no-cache --virtual .build-deps git file re2c autoconf make g++ php7-dev=7.1.5-r0 libmemcached-dev cyrus-sasl-dev zlib-dev musl rabbitmq-c-dev pcre-dev && \
    git clone --depth=1 -b 2.0.4 https://github.com/igbinary/igbinary.git /tmp/php-igbinary && \
    cd /tmp/php-igbinary && \
    phpize && ./configure CFLAGS="-O2 -g" --enable-igbinary && make && make install && \
    cd .. && rm -rf /tmp/php-igbinary/ && \
    echo 'extension=igbinary.so' >> /etc/php7/conf.d/igbinary.ini && \
    \
    git clone --depth=1 -b v3.0.3 https://github.com/php-memcached-dev/php-memcached.git /tmp/php-memcached && \
    cd /tmp/php-memcached && \
    phpize && ./configure --disable-memcached-sasl && make && make install && \
    cd .. && rm -rf /tmp/php-memcached/ && \
    echo 'extension=memcached.so' >> /etc/php7/conf.d/memcached.ini && \
    \
    git clone --depth=1 -b 3.1.2 https://github.com/phpredis/phpredis.git /tmp/php-redis && \
    cd /tmp/php-redis && \
    phpize &&  ./configure --enable-redis-igbinary && make && make install && \
    cd .. && rm -rf /tmp/php-redis/ && \
    echo 'extension=redis.so' >> /etc/php7/conf.d/redis.ini && \
    \
    git clone --depth=1 -b v1.9.0 https://github.com/pdezwart/php-amqp.git /tmp/php-amqp && \
    cd /tmp/php-amqp && \
    phpize && ./configure && make && make install && \
    cd .. && rm -rf /tmp/php-amqp/ && \
    echo 'extension=amqp.so' >> /etc/php7/conf.d/amqp.ini && \
    \
    # Older drivers do not support LibreSSL https://github.com/mongodb/mongo-php-driver/issues/507
    git clone --depth=1 -b 1.1.10 https://github.com/mongodb/mongo-php-driver.git /tmp/php-mongodb && \
    cd /tmp/php-mongodb && \
    git submodule update --init && \
    phpize && ./configure --prefix=/usr && make && make install && \
    cd .. && rm -rf /tmp/php-mongodb/ && \
    echo 'extension=mongodb.so' >> /etc/php7/conf.d/mongodb.ini && \
    \
    apk del .build-deps

COPY ./conf/php.ini /etc/php7/php.ini
COPY ./conf/www.conf /etc/php7/php-fpm.d/www.conf
COPY ./conf/php-fpm.conf /etc/php7/php-fpm.conf

WORKDIR /var/www

EXPOSE 9000
CMD ["/usr/sbin/php-fpm7", "-R"]
