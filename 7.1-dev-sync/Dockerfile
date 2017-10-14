FROM lagun4ik/php7-fpm:7.1.10-r0-dev

USER root

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY ./bin/ /usr/bin/

RUN apk add --update --no-cache rsync busybox-suid
RUN chmod +x /usr/bin/composer /usr/bin/composer-sync /docker-entrypoint.sh

USER www-data

CMD ["composer-sync"]
ENTRYPOINT ["/docker-entrypoint.sh"]
