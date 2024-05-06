FROM debian:buster

RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

COPY tools/script.sh .
RUN cmod +x /script.sh

EXPOSE 3306

HEALTHCHECK --interval=30s --timeout=30s --retries=3 \
    CMD  mysqladmin ping -h localhost || exit 1

CMD ["./script.sh"]