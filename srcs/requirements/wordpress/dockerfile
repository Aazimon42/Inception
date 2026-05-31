FROM debian:bookworm

RUN apt update -y && apt upgrade -y && apt install -y curl php-fpm php-mysqli

RUN mkdir -p /run/php && chown www-data:www-data /run/php
COPY ./wordpress.conf /etc/php/8.2/fpm/pool.d

ENTRYPOINT ["./wordpress.sh"]