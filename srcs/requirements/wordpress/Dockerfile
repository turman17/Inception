FROM debian:bullseye

WORKDIR /var/www/html/

RUN apt-get update -y \
    && apt-get install wget curl \
    php php-mysql php-curl php-gd php-mbstring \
    php-xml php-xmlrpc php-soap php-intl php-zip \
    php-fpm php-cgi php-cli -y\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY tools/script.sh .
COPY tools/www.conf /etc/php/7.4/fpm/pool.d/

RUN mv ./script.sh /bin \
	&& chmod +x /bin/script.sh

RUN export PATH="$PATH:/usr/sbin" \
    && mkdir -p /run/php

EXPOSE 9000

ENTRYPOINT [ "script.sh" ]

CMD [ "php-fpm7.4" , "-F" ]