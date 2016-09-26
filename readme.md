#🏋 Lightweight Docker Image for PHP7 (cli&fpm)
 [![Build Status](https://travis-ci.org/lagun4ik/docker-php-dev-stack.svg)](https://travis-ci.org/lagun4ik/docker-php-dev-stack)

This PHP docker image based on [Alpine](https://hub.docker.com/_/alpine/). Alpine is based on [Alpine Linux](http://www.alpinelinux.org), lightweight Linux distribution based on [BusyBox](https://hub.docker.com/_/busybox/). The size of the image is very small, less than 70 MB!

### Images

* [lagun4ik/docker-php7-fpm:latest](https://hub.docker.com/r/lagun4ik/docker-php7-fpm/) - production version
* [lagun4ik/docker-php7-fpm:dev](https://hub.docker.com/r/lagun4ik/docker-php7-fpm/) - PHPUnit, Composer, Xdebug - switch to a branch (or tag) 

## Getting The Image

This image is published in the [Docker Hub](https://hub.docker.com/r/lagun4ik/docker-php7-fpm/). Simply run this command below to get it to your machine.
    
### PHP Configuration

The config is set using environments
```docker
#default values
PHP_MEMORY_LIMIT=256M
PHP_ERROR_REPORTING=E_ALL
PHP_DISPLAY_ERRORS=Off
PHP_DISPLAY_STARTUP_ERRORS=Off
PHP_POST_MAX_SIZE=20M
PHP_MAX_UPLOAD_FILESIZE=10M
PHP_MAX_FILE_UPLOADS=20
PHP_DATE_TIMEZONE=Europe/Minsk
PHP_OPCACHE_ENABLE=1
PHP_OPCACHE_ENABLE_CLI=0
```

### PHP Modules
```
amqp
bcmath
bz2
Core
ctype
curl
date
dom
fileinfo
filter
gd
gettext
gmp
hash
iconv
json
libxml
mbstring
mcrypt
memcached
mongodb
mysqli
odbc
openssl
pcntl
pcre
PDO
pdo_dblib
pdo_mysql
PDO_ODBC
pdo_pgsql
pdo_sqlite
redis
Reflection
session
SimpleXML
soap
SPL
sqlite3
standard
tokenizer
xdebug
xml
xmlreader
xmlrpc
xmlwriter
Zend OPcache
zip

[Zend Modules]
Zend OPcache
```
