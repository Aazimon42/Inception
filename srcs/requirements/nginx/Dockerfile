FROM debian:bookworm

RUN apt update -y && apt upgrade -y && apt install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/certificate.crt -keyout /etc/nginx/ssl/certificate.key -subj "/C=FR/ST=NA/L=Angouleme/O=42/OU=42/CN=$DOMAIN_NAME/UID=edi-maio"

RUN mkdir -p /var/run/nginx
COPY ./nginx.conf /etc/nginx/conf.d/nginx.conf.template

# We make a copy of the script so it can be executed from the image
WORKDIR /usr/local/bin/
COPY ./nginx.sh .
RUN chmod +x nginx.sh

ENTRYPOINT ["/usr/local/bin/nginx.sh"]