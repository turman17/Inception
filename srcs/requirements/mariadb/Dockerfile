FROM debian:bullseye

# Install MariaDB server and netcat (nc)
RUN apt-get update -y && apt-get install -y \
    mariadb-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the script to the container
COPY tools/script.sh /bin/script.sh

# Make the script executable
RUN chmod +x /bin/script.sh

# Set the entrypoint to your script
ENTRYPOINT ["/bin/script.sh"]

# Default command to start MariaDB safely
CMD ["mysqld_safe", "--bind-address=0.0.0.0"]