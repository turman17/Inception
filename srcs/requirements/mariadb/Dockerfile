FROM debian:oldstable

# Install MariaDB and utilities
RUN apt-get update && apt-get install -y \
    mariadb-server \
    net-tools \
    procps \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/bin

COPY tools/script.sh .
RUN chmod +x script.sh

EXPOSE 3306

HEALTHCHECK --interval=30s --timeout=30s --retries=3 \
    CMD mysqladmin --socket=/run/mysqld/mysqld.sock ping -h localhost || exit 1

COPY tools/entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
CMD ["sh", "-c", "./script.sh && exec mysqld_safe"]
