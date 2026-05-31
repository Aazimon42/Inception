FROM debian:bookworm

# gettext-base is used to retreive environment variables for DB config
RUN apt update -y && apt upgrade -y && apt install -y mariadb-server mariadb-client gettext-base

COPY ./mariadb.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

ENTRYPOINT ["./mariadb.sh"]