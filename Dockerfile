FROM lagun4ik/docker-php7-fpm

MAINTAINER ivan@lagunovsky.com

ENV TERM=xterm

RUN apk add --update --no-cache git nano unzip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN php -r "readfile('http://files.drush.org/drush.phar');" > drush \
    && chmod +x drush \
    && mv drush /usr/local/bin

RUN curl -OsSL https://phar.phpunit.de/phpunit.phar \
    && chmod +x phpunit.phar \
    && mv phpunit.phar /usr/local/bin/phpunit
