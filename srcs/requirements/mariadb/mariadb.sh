#!/bin/sh

if [ -f /entrypoint-initdb.d/init.sql.template ];
    then
        envsubst < ./init.sql.template > /etc/mysql/init.sql
fi

exec "mysqld"