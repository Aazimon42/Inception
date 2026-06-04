FROM debian:bookworm

# gettext-base is used to retrieve environment variables for DB config
RUN apt update -y && apt upgrade -y && apt install -y mariadb-server mariadb-client gettext-base

COPY ./mariadb.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN mkdir ./entrypoint-initdb.d
COPY ./tools/init.sql.template /entrypoint-initdb.d
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# We make a copy of the script so it can be executed from the image
WORKDIR /var/lib/mysql/
COPY ./mariadb.sh .
RUN chmod +x mariadb.sh

ENTRYPOINT ["/var/lib/mysql/mariadb.sh"]