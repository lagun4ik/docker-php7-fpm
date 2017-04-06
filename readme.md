# 🏋 Lightweight Docker Image for PHP7 (cli&fpm)
 [![Build Status](https://travis-ci.org/lagun4ik/docker-php7-fpm.svg)](https://travis-ci.org/lagun4ik/docker-php7-fpm)

This PHP docker image based on [Alpine](https://hub.docker.com/_/alpine/). Alpine is based on [Alpine Linux](http://www.alpinelinux.org), lightweight Linux distribution based on [BusyBox](https://hub.docker.com/_/busybox/). The size of the image is very small, less than 70 MB!

### Images

* [lagun4ik/php7-fpm:latest](https://hub.docker.com/r/lagun4ik/php7-fpm/) - production version
* [lagun4ik/php7-fpm:dev](https://hub.docker.com/r/lagun4ik/php7-fpm/) - PHPUnit, Composer, Xdebug - switch to a branch (or tag) 

## Getting The Image

This image is published in the [Docker Hub](https://hub.docker.com/r/lagun4ik/php7-fpm/). Simply run this command below to get it to your machine.
    
### PHP Configuration

The config is set using environments. See `.env.example`

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
igbinary
json
libxml
mbstring
mcrypt
memcached
mongodb
mysqli
mysqlnd
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
Phar
readline
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
zlib

[Zend Modules]
Xdebug
Zend OPcache
```
