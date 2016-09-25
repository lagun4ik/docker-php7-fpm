FROM alpine:3.4

MAINTAINER ivan@lagunovsky.com

ENV PHP_MEMORY_LIMIT=256M \
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

RUN apk upgrade --update --no-cache && \
    apk add --update --no-cache \
	ca-certificates \
	curl \
    bash

RUN	echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
	apk add --update --no-cache \
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
		php7-xdebug \
		php7-mongodb \
		php7-redis \
		php7-amqp \
		php7-pcntl \
		php7-opcache \
		php7-mbstring \
		php7-fpm \
		php7 && \
	rm -rf /etc/php7/php.ini && \
    ln -s /usr/bin/php7 /usr/bin/php && \
    sed -i "s|;*daemonize\s*=\s*yes|daemonize = no|g" /etc/php7/php-fpm.conf && \
    sed -i "s|;*listen\s*=\s*127.0.0.1:9000|listen = 9000|g" /etc/php7/php-fpm.d/www.conf && \
    sed -i "s|;*listen\s*=\s*/||g" /etc/php7/php-fpm.d/www.conf && \
    mkdir /var/www

RUN apk add --update --no-cache --virtual .build-deps git file re2c autoconf make g++ php7-dev libmemcached-dev cyrus-sasl-dev && \
    cd /tmp && git clone --depth=1 -b php7 https://github.com/php-memcached-dev/php-memcached.git && \
    cd /tmp/php-memcached && \
    phpize7 && \
    ./configure --disable-memcached-sasl --with-php-config=php-config7 && \
    make && make install && \
    mv /tmp/php-memcached/modules/memcached.so /usr/lib/php7/modules && \
    rm -rf /tmp/php-memcached/ && \
    echo 'extension=memcached.so' >> /etc/php7/conf.d/memcached.ini && \
    apk del .build-deps && \
    apk add --update --na-cache libmemcached

COPY ./conf/php.ini /etc/php7/php.ini

WORKDIR /var/www
VOLUME ["/var/www"]

EXPOSE 9000
CMD ["/usr/sbin/php-fpm7", "-R"]
