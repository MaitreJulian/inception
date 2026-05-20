FROM debian:bookworm
RUN apt update -y && \
    apt upgrade -y && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/scriptdb.sh .
RUN chmod +x scriptdb.sh
CMD ["./scriptdb.sh"]
