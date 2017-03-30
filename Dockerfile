FROM alpine:3.4

MAINTAINER ivan@lagunovsky.com

ENV PHP_MEMORY_LIMIT=256M \
   PHP_ERROR_REPORTING=E_ALL \
   TRACK_ERRORS=0 \
   PHP_DISPLAY_ERRORS=0 \
   PHP_DISPLAY_STARTUP_ERRORS=0 \
   PHP_POST_MAX_SIZE=20M \
   PHP_MAX_UPLOAD_FILESIZE=10M \
   PHP_MAX_FILE_UPLOADS=20 \
   PHP_DATE_TIMEZONE=Europe/Minsk \
   PHP_VARIABLES_ORDER=EGPCS \
   MAX_EXECUTION_TIME=60 \
   MAX_INPUT_TIME=60 \
   PHP_OPCACHE_ENABLE=1 \
   PHP_OPCACHE_ENABLE_CLI=0 \
   PHP_OPCACHE_MEMORY_CONSUMPTION=256 \
   PHP_OPCACHE_INTERNED_STRINGS_BUFFER=32 \
   PHP_OPCACHE_MAX_ACCELERATED_FILES=100000 \
   PHP_OPCACHE_USE_CWD=0 \
   PHP_OPCACHE_VALIDATE_TIMESTAMPS=1 \
   PHP_OPCACHE_REVALIDATE_FREQ=2 \
   PHP_OPCACHE_ENABLE_FILE_OVERRIDE=1
   
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

RUN apk upgrade --update --no-cache && \
    apk add --update --no-cache \
    ca-certificates \
    curl \
    bash

RUN apk add --update --no-cache \
        php7-mcrypt \
        php7-soap \
        php7-openssl \
        php7-gmp \
        php7-pdo_odbc \
        php7-json \
        php7-dom \
        php7-pdo \
        php7-zip \
        php7-mysqli \
        php7-sqlite3 \
        php7-pdo_pgsql \
        php7-bcmath \
        php7-gd \
        php7-odbc \
        php7-pdo_mysql \
        php7-pdo_sqlite \
        php7-gettext \
        php7-xmlreader \
        php7-xmlrpc \
        php7-xml \
        php7-bz2 \
        php7-iconv \
        php7-pdo_dblib \
        php7-curl \
        php7-ctype \
        php7-mongodb \
        php7-redis \
        php7-amqp \
        php7-pcntl \
        php7-phar \
        php7-opcache \
        php7-mbstring \
        php7-zlib \
        php7-fpm \
        php7 && \
    rm -rf /etc/php7/php.ini && \
    ln -s /usr/bin/php7 /usr/bin/php && \
    mkdir /var/www

RUN apk add --update --no-cache --virtual .build-deps git file re2c autoconf make g++ php7-dev libmemcached-dev cyrus-sasl-dev zlib-dev && \
    git clone --depth=1 https://github.com/php-memcached-dev/php-memcached.git /tmp/php-memcached && \
    cd /tmp/php-memcached && \
    phpize7 && \
    ./configure --disable-memcached-sasl --with-php-config=php-config7 && \
    make && make install && \
    mv /tmp/php-memcached/modules/memcached.so /usr/lib/php7/modules && \
    rm -rf /tmp/php-memcached/ && \
    echo 'extension=memcached.so' >> /etc/php7/conf.d/memcached.ini && \
    apk del .build-deps && \
    apk add --update --no-cache libmemcached

COPY ./conf/php.ini /etc/php7/php.ini
COPY ./conf/www.conf /etc/php7/php-fpm.d/www.conf
COPY ./conf/php-fpm.conf /etc/php7/php-fpm.conf

WORKDIR /var/www

EXPOSE 9000
CMD ["/usr/sbin/php-fpm7", "-R"]
