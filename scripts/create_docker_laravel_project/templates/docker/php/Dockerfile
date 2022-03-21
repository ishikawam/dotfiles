# local php

FROM php:PHP_VERSION-fpm-alpine

# composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# memory_limit
COPY ./default.ini /usr/local/etc/php/conf.d/default.ini
