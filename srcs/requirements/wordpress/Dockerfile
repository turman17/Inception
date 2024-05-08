FROM debian:bullseye

WORKDIR /var/www/html/

RUN apt-get update -y \
    && apt-get install -y wget curl \
    php php-mysql php-curl php-gd php-mbstring \
    php-xml php-xmlrpc php-soap php-intl php-zip \
    php-fpm php-cgi php-cli \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

COPY tools/script.sh /bin/wordpress.sh
COPY tools/www.conf /etc/php/7.4/fpm/pool.d/

RUN chmod +x /bin/wordpress.sh

RUN export PATH="$PATH:/usr/sbin" \
    && mkdir -p /run/php

EXPOSE 9000

ENTRYPOINT [ "wordpress.sh" ]

CMD [ "php-fpm7.4" , "-F" ]