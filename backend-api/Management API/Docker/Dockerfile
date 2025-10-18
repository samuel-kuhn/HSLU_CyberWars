FROM php:7.4-fpm-alpine
# we really should upgrade to php 8.0 soon

COPY main.php /usr/src/api/
COPY backup-database.sh /usr/src/api/

WORKDIR /usr/src/api

RUN apk add --no-cache sqlite-dev sqlite \
    && docker-php-ext-install pdo_sqlite \
    && apk del sqlite-dev

CMD [ "php", "-S", "0.0.0.0:8080", "main.php" ]
