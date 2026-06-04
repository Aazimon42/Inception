#!/bin/sh

if [ -f /etc/nginx/conf.d/nginx.conf.template ]; then
    envsubst < /etc/nginx/conf.d/nginx.conf.template > /etc/nginx/conf.d/nginx.conf
fi

exec nginx -g "daemon off;"