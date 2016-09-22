FROM alpine:3.4

MAINTAINER ivan@lagunovsky.com

ENV PHP_INI_DIR /etc/php/7.0/fpm/
ENV PHP_VERSION 7.0.11
ENV PHP_FILENAME php-7.0.10.tar.xz
ENV PHP_SHA256 d4cccea8da1d27c11b89386f8b8e95692ad3356610d571253d00ca67d524c735
ENV GPG_KEYS 1A4E8B7277C42E53DBA9C7B9BCAA30EA9C0D5763
ENV PHP_USER root
ENV PHPIZE_DEPS \
    autoconf \
	file \
	g++ \
	gcc \
	libc-dev \
	make \
	pkgconf \
	re2c \
    readline-dev \
    recode-dev \
    openssl-dev \
    icu-dev \
    pcre-dev \
    libbz2 \
    libpq \
    jpeg-dev \
    libpng-dev \
    freetype-dev \
    libmcrypt-dev \
    gd-dev \
    gmp-dev \
    bzip2-dev \
    libintl \
    libxpm-dev \
    gettext-dev \
    libmemcached-dev \
    curl-dev \
    gnupg \
    libedit-dev \
    libxml2-dev \
    openssl-dev \
    sqlite-dev \
    git \
    libmemcached

ENV PHP_MEMORY_LIMIT=256M
ENV PHP_ERROR_REPORTING=E_ALL
ENV PHP_DISPLAY_ERRORS=On
ENV PHP_DISPLAY_STARTUP_ERRORS=On
ENV PHP_POST_MAX_SIZE=20M
ENV PHP_MAX_UPLOAD_FILESIZE=10M
ENV PHP_MAX_FILE_UPLOADS=20
ENV PHP_DATE_TIMEZONE=Europe/Minsk
ENV PHP_OPCACHE_ENABLE=0
ENV PHP_OPCACHE_ENABLE_CLI=0
ENV PHP_XDEBUG_REMOTE_AUTOSTART=Off
ENV PHP_XDEBUG_REMOTE_ENABLE=Off
ENV PHP_XDEBUG_REMOTE_HANDLER="dbgp"
ENV PHP_XDEBUG_REMOTE_HOST="localhost"
ENV PHP_XDEBUG_REMOTE_PORT=9001
ENV PHP_XDEBUG_REMOTE_MODE=req
ENV PHP_XDEBUG_IDEKEY="PHPSTORM"

# ensure www-data user exists
RUN set -x \
	&& addgroup -g 82 -S www-data \
	&& adduser -u 82 -D -S -G www-data www-data

COPY scripts/docker-php-ext-* /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-php-ext-*

RUN apk add --update --no-cache --virtual .persistent-deps \
	ca-certificates \
	curl \
    bash

RUN mkdir -p $PHP_INI_DIR/conf.d \
 && set -xe \
	&& apk add --update --no-cache --virtual .build-deps $PHPIZE_DEPS \
	&& curl -fSL "http://php.net/get/$PHP_FILENAME/from/this/mirror" -o "$PHP_FILENAME" \
	&& echo "$PHP_SHA256 *$PHP_FILENAME" | sha256sum -c - \
	&& curl -fSL "http://php.net/get/$PHP_FILENAME.asc/from/this/mirror" -o "$PHP_FILENAME.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& for key in $GPG_KEYS; do \
            gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
        done \
	&& gpg --batch --verify "$PHP_FILENAME.asc" "$PHP_FILENAME" \
	&& rm -r "$GNUPGHOME" "$PHP_FILENAME.asc" \
	&& mkdir -p /usr/src \
	&& tar -Jxf "$PHP_FILENAME" -C /usr/src \
	&& mv "/usr/src/php-$PHP_VERSION" /usr/src/php \
	&& rm "$PHP_FILENAME" \
	&& cd /usr/src/php \
	&& ./configure \
		--with-config-file-path="$PHP_INI_DIR" \
		--with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
		--enable-fpm \
		--disable-cgi \
		--enable-mysqlnd \
		--enable-mbstring \
		--with-curl \
		--with-libedit \
		--with-openssl \
		--with-zlib \
        --enable-intl \
        --enable-pcntl \
        --enable-force-cgi-redirect \
        --with-fpm-user=$PHP_USER \
        --with-fpm-group=$PHP_USER \
        --with-mcrypt=/usr \
        --with-pcre-regex \
        --enable-pdo \
        --with-openssl \
        --with-openssl-dir=/usr/bin \
        --with-sqlite3=/usr \
        --with-pdo-sqlite=/usr \
        --enable-inline-optimization \
        --with-icu-dir=/usr \
        --with-curl=/usr/bin \
        --with-bz2 \
        --enable-sockets \
        --with-mysqli=mysqlnd \
        --with-pdo-mysql=mysqlnd \
        --with-gd \
        --with-tsrm-pthreads \
        --with-jpeg-dir=/usr \
        --with-png-dir=/usr \
        --with-xpm-dir=/usr \
        --with-freetype-dir=/usr \
        --enable-gd-native-ttf \
        --with-pear \
        --with-mcrypt \
        --enable-exif \
        --with-gettext \
        --enable-bcmath \
        --with-openssl \
        --with-readline \
        --with-recode \
        --with-zlib \
	&& make -j"$(getconf _NPROCESSORS_ONLN)" \
	&& make install \
	&& { find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
	&& make clean \
	&& runDeps="$( \
		scanelf --needed --nobanner --recursive /usr/local \
			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			| sort -u \
			| xargs -r apk info --installed \
			| sort -u \
	)" \
	&& apk add --update --no-cache --virtual .php-rundeps $runDeps \
  && cd /tmp && git clone --depth=1 https://github.com/mongodb/mongo-php-driver.git \
    && cd /etc/mongo-php-driver \
    && git submodule update --init \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && touch $PHP_INI_DIR/conf.d/ext-mongodb.ini \
    && echo 'extension=mongodb.so' >> $PHP_INI_DIR/conf.d/ext-mongodb.ini \
    && rm -rf /tmp/mongo-php-driver
  && cd /tmp && git clone --depth=1 -b php7 https://github.com/phpredis/phpredis.git \
    && cd /etc/phpredis \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && touch $PHP_INI_DIR/conf.d/ext-redis.ini \
    && echo 'extension=redis.so' >> $PHP_INI_DIR/conf.d/ext-redis.ini \
    && rm -rf /tmp/phpredis
  && cd /tmp && git clone --depth=1 -b php7 https://github.com/php-memcached-dev/php-memcached.git \
    && cd /etc/php-memcached \
    && phpize \
    && ./configure --disable-memcached-sasl \
    && make \
    && make install \
    && touch $PHP_INI_DIR/conf.d/ext-redis.ini \
    && echo 'extension=memcached.so' >> $PHP_INI_DIR/conf.d/ext-redis.ini \
    && rm -rf /tmp/php-memcached
  && cd /tmp && git clone --depth=1 https://github.com/xdebug/xdebug.git \
    && cd /etc/xdebug \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && echo 'extension=xdebug.so' >> $PHP_INI_DIR/conf.d/ext-xdebug.ini \
    && rm -rf /tmp/xdebug
  && docker-php-ext-install-pecl zip \
  && docker-php-ext-enable opcache \
  && apk del .build-deps

COPY ./conf/php.ini $PHP_INI_DIR

RUN set -ex \
	&& cd /usr/local/etc \
	&& if [ -d php-fpm.d ]; then \
		# for some reason, upstream's php-fpm.conf.default has "include=NONE/etc/php-fpm.d/*.conf"
		sed 's!=NONE/!=!g' php-fpm.conf.default | tee php-fpm.conf > /dev/null; \
		cp php-fpm.d/www.conf.default php-fpm.d/www.conf; \
	else \
		# PHP 5.x don't use "include=" by default, so we'll create our own simple config that mimics PHP 7+ for consistency
		mkdir php-fpm.d; \
		cp php-fpm.conf.default php-fpm.d/www.conf; \
		{ \
			echo '[global]'; \
			echo 'include=etc/php-fpm.d/*.conf'; \
		} | tee php-fpm.conf; \
	fi \
	&& { \
		echo '[global]'; \
		echo 'error_log = /proc/self/fd/2'; \
		echo; \
		echo '[www]'; \
		echo '; if we send this to /proc/self/fd/1, it never appears'; \
		echo 'access.log = /proc/self/fd/2'; \
		echo; \
		echo 'clear_env = no'; \
		echo; \
		echo '; Ensure worker stdout and stderr are sent to the main error log.'; \
		echo 'catch_workers_output = yes'; \
	} | tee php-fpm.d/docker.conf \
	&& { \
		echo '[global]'; \
		echo 'daemonize = no'; \
		echo; \
		echo '[www]'; \
		echo 'listen = [::]:9000'; \
	} | tee php-fpm.d/zz-docker.conf

WORKDIR /var/www/

VOLUME ["/www"]

EXPOSE 9000
CMD ["php-fpm"]
