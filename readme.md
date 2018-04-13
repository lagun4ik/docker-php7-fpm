# 🏋 Lightweight Docker Image for PHP7 (cli&fpm)
 [![Build Status](https://travis-ci.org/lagun4ik/docker-php7-fpm.svg)](https://travis-ci.org/lagun4ik/docker-php7-fpm)


This PHP docker image based on [Alpine](https://hub.docker.com/_/alpine/).

## Supported tags and `Dockerfile` links

 - [`7.2.4-r0`, `latest` (7.1/Dockerfile)](https://github.com/lagun4ik/docker-php7-fpm/blob/master/images/core/Dockerfile)
 - [`7.2.4-r0-dev`, `dev` (7.1-dev/Dockerfile)](https://github.com/lagun4ik/docker-php7-fpm/blob/master/images/dev/Dockerfile) - PHPUnit, Composer, Xdebug
 - [`7.2.4-r0-dev-sync`, `dev-sync` (7.1-dev/Dockerfile)](https://github.com/lagun4ik/docker-php7-fpm/blob/master/images/dev-sync/Dockerfile) - for the improve performance volumes on Windows or macOS

## Getting The Image

This image is published in the [Docker Hub](https://hub.docker.com/r/lagun4ik/php7-fpm/)

### PHP Configuration

The config is set using environments. See `.env.example`

## :dev-sync (Performance tuning for volume mounts)

See [docker-compose.yml](https://github.com/lagun4ik/docker-php7-fpm/blob/master/dev-sync/docker-compose.yml) for example

You can run `composer-sync loop [SECONDS]` in the container for continuous synchronization of volumes 

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
Zend OPcache
```
