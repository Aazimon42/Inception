#!/bin/bash

mkdir -p /var/run/vsftpd/empty

useradd -m -s /bin/bash $FTPUSER -d /var/www/html
usermod -aG www-data $FTPUSER
chmod g+s /var/www/html
echo "$FTPUSER:$FTPPASS" | chpasswd

exec vsftpd /etc/vsftpd.conf