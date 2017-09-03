FROM lagun4ik/php7-fpm:7.1.9-r1-dev

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY ./bin/ /usr/bin/

RUN apk add --update --no-cache rsync
RUN chmod +x /usr/bin/composer /usr/bin/composer-sync /docker-entrypoint.sh

CMD ["composer-sync"]
ENTRYPOINT ["/docker-entrypoint.sh"]
