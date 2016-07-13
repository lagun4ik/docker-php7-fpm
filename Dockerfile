FROM ubuntu:trusty

MAINTAINER ivan@lagunovsky.com

ENV PHP_INI_DIR /etc/php/7.0/fpm/
ENV PHP_VERSION 7.0.8
ENV PHP_FILENAME php-7.0.8.tar.xz
ENV PHP_SHA256 0a2142c458b0846f556b16da1c927d74c101aa951bb840549abe5c58584fb394
ENV PHP_USER root
ENV PHP_AUTOCONF /usr/bin/autoconf
ENV PHP_INI_TYPE production

# persistent / runtime deps
RUN apt-get update && apt-get install -y ca-certificates wget librecode0 libmagickwand-dev libsasl2-dev libmemcached-dev imagemagick libsqlite3-0 libxml2 --no-install-recommends && rm -r /var/lib/apt/lists/*

# phpize deps
RUN apt-get update && apt-get install -y build-essential autoconf file g++ gcc libc-dev make pkg-config re2c --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN mkdir -p $PHP_INI_DIR/conf.d \
    && mkdir -p $PHP_INI_DIR/pool.d

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "1A4E8B7277C42E53DBA9C7B9BCAA30EA9C0D5763";

RUN buildDeps=" \
        libcurl4-openssl-dev \
        libreadline6-dev \
        librecode-dev \
        libzip-dev \
        libsqlite3-dev \
        libssl-dev \
        libxml2-dev \
        xz-utils \
        libicu-dev \
        libpcre3-dev \
        libbz2-dev \
        libpq-dev \
        libt1-dev \
        libjpeg8 \
        libpng12-dev \
        libfreetype6-dev \
        libmcrypt-dev \
        libgd2-xpm-dev \
        libgmp-dev \
        libmysqlclient-dev \
        curl \
    " \
    && set -x \
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
    && curl -fSL "http://php.net/get/$PHP_FILENAME/from/this/mirror" -o "$PHP_FILENAME" \
    && echo "$PHP_SHA256 *$PHP_FILENAME" | sha256sum -c - \
    && curl -fSL "http://php.net/get/$PHP_FILENAME.asc/from/this/mirror" -o "$PHP_FILENAME.asc" \
    && gpg --verify "$PHP_FILENAME.asc" \
    && mkdir -p /usr/src/php \
    && tar -xf "$PHP_FILENAME" -C /usr/src/php --strip-components=1 \
    && rm "$PHP_FILENAME"*

RUN cd /usr/src/php && ./configure \
        --with-config-file-path="$PHP_INI_DIR" \
        --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
        --disable-cgi \
        --enable-intl \
        --enable-pcntl \
        --enable-fpm \
        --enable-mbstring \
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
        --with-pear \
        --with-tsrm-pthreads \
        --with-jpeg-dir=/usr \
        --with-png-dir=/usr \
        --with-xpm-dir=/usr \
        --with-freetype-dir=/usr \
        --enable-gd-native-ttf \
        --with-mcrypt \
        --enable-exif \
        --with-gettext \
        --enable-bcmath \
        --with-openssl \
        --with-readline \
        --with-recode \
        --with-zlib \
    && make -j"$(nproc)" \
    && make install \
    && { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; }

COPY scripts/docker-php-ext-* /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-php-ext-*

ENV PHP_AMQP_BUILD_DEPS libtool automake pkg-config libzmq-dev

RUN apt-get update && apt-get install -y git $PHP_AMQP_BUILD_DEPS --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y libmagickwand-dev libvips-dev libgsf-1-dev libmagickcore-dev libevent-dev --no-install-recommends && rm -r /var/lib/apt/lists/*

# MONGO
RUN cd /etc && git clone --depth=1 -b 1.1.1 https://github.com/mongodb/mongo-php-driver.git \
    && cd /etc/mongo-php-driver \
    && git submodule update --init \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && touch $PHP_INI_DIR/conf.d/ext-mongodb.ini \
    && echo 'extension=mongodb.so' >> $PHP_INI_DIR/conf.d/ext-mongodb.ini

# REDIS
RUN cd /etc && git clone --depth=1 -b php7 https://github.com/phpredis/phpredis.git \
    && cd /etc/phpredis \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && touch $PHP_INI_DIR/conf.d/ext-redis.ini \
    && echo 'extension=redis.so' >> $PHP_INI_DIR/conf.d/ext-redis.ini

# MEMCACHED
RUN cd /etc && git clone --depth=1 -b php7 https://github.com/php-memcached-dev/php-memcached.git \
    && cd /etc/php-memcached \
    && phpize \
    && ./configure --disable-memcached-sasl \
    && make \
    && make install \
    && touch $PHP_INI_DIR/conf.d/ext-redis.ini \
    && echo 'extension=memcached.so' >> $PHP_INI_DIR/conf.d/ext-redis.ini

RUN docker-php-ext-install-pecl zip
RUN php -m | grep zip
RUN docker-php-ext-enable opcache

RUN apt-get update && apt-get install git openssh-client curl -y --no-install-recommends && rm -rf /var/lib/apt/lists/*

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

RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $buildDeps $PHP_AMQP_BUILD_DEPS && apt-get clean all

RUN curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

RUN mkdir -p /var/www/
WORKDIR /var/www/

EXPOSE 9000
CMD ["php-fpm", "-R"]
