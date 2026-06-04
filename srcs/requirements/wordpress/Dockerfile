FROM debian:bookworm

RUN apt update -y && apt upgrade -y && apt install -y curl php-fpm php-mysqli

RUN mkdir -p /run/php
RUN chown www-data:www-data /run/php
COPY ./wordpress.conf /etc/php/8.2/fpm/pool.d

# We make a copy of the script so it can be executed from the image
WORKDIR /var/www/html
COPY ./wordpress.sh .
RUN chmod +x wordpress.sh

ENTRYPOINT ["/var/www/html/wordpress.sh"]