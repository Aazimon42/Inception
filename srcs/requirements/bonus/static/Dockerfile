FROM debian:bookworm

RUN apt update && apt install -y apache2

COPY ./index.html /tmp/index.html

EXPOSE 80
CMD cp /tmp/index.html /var/www/html/index.html && apache2ctl -D FOREGROUND