FROM php:7.0-fpm
MAINTAINER "Duc Anh Babim" <ducanh.babim@yahoo.com>

RUN rm -f /etc/motd && \
    echo "---" > /etc/motd && \
    echo "Support by Duc Anh Babim. Contact: ducanh.babim@yahoo.com" >> /etc/motd && \
    echo "---" >> /etc/motd && \
    echo "Babim Container Framework \l" > /etc/issue && \
    echo "Babim Container Framework" > /etc/issue.net && \
    touch "/(C) Babim"

RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev locales \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring opcache pdo pdo_mysql pdo_pgsql

RUN dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini
# set upload tweak
RUN { \
		echo 'display_errors = On'; \
		echo 'cgi.fix_pathinfo=0'; \
		echo 'upload_max_filesize = 520M'; \
		echo 'post_max_size = 520M'; \
		echo 'max_input_time = 3600'; \
		echo 'max_execution_time = 3600'; \
	} > /usr/local/etc/php/conf.d/upload.ini

RUN mkdir -p /etc-start/php/conf.d/ && cp -R /usr/local/etc/php/conf.d/ /etc-start/php/conf.d/

# PECL extensions
RUN pecl install APCu-4.0.10 redis memcached \
	&& docker-php-ext-enable apcu redis memcached

ENV LC_ALL C.UTF-8
ENV TZ Asia/Ho_Chi_Minh

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9000
WORKDIR /var/www
VOLUME /var/www /usr/local/etc/php/conf.d
CMD ["php-fpm"]
