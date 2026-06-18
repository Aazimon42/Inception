FROM debian:bookworm

RUN apt update && apt install -y vsftpd && rm -rf /var/lib/apt/lists/*

COPY ./vsftpd.conf /etc/vsftpd.conf
COPY ./ftp.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

ENTRYPOINT ["/usr/local/bin/setup.sh"]