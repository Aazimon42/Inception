#!/bin/sh

if [ -f /entrypoint-initdb.d/init.sql.template ]; then
    envsubst < /entrypoint-initdb.d/init.sql.template > /etc/mysql/init.sql
fi

exec mysqld --init-file=/etc/mysql/init.sql