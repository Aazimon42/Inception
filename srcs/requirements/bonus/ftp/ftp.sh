#!/bin/bash

mkdir -p /var/run/vsftpd/empty

useradd -m -s /bin/bash $FTP_USER -d /var/www/html
usermod -aG www-data $FTP_USER
chmod g+s /var/www/html
echo "$FTP_USER:$FTP_PASS" | chpasswd

exec vsftpd /etc/vsftpd.conf