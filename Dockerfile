FROM php:5.6-fpm
MAINTAINER "Duc Anh Babim" <ducanh.babim@yahoo.com>

RUN rm -f /etc/motd && \
    echo "---" > /etc/motd && \
    echo "Support by Duc Anh Babim. Contact: ducanh.babim@yahoo.com" >> /etc/motd && \
    echo "---" >> /etc/motd && \
    echo "Babim Container Framework \l" > /etc/issue && \
    echo "Babim Container Framework" > /etc/issue.net && \
    touch "/(C) Babim"

RUN apt-get update && apt-get install -y unzip tar wget curl \
	bzip2 locales \
	libcurl4-openssl-dev \
	libfreetype6-dev \
	libicu-dev \
	libjpeg-dev \
	libmcrypt-dev \
	libmemcached-dev \
	libpng12-dev \
	libpq-dev \
	libxml2-dev \
	&& rm -rf /var/lib/apt/lists/*

RUN dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8

RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd intl mbstring mcrypt mysql opcache pdo_mysql pdo_pgsql pgsql zip

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

RUN sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php/conf.d/upload.ini && \
    sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Asia\/Ho_Chi_Minh/g' /etc/php/conf.d/upload.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/conf.d/upload.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 520M/" /etc/php/conf.d/upload.ini && \
    sed -i "s/post_max_size = 8M/post_max_size = 520M/" /etc/php/conf.d/upload.ini && \
    sed -i "s/max_input_time = 60/max_input_time = 3600/" /etc/php/conf.d/upload.ini && \
    sed -i "s/max_execution_time = 30/max_execution_time = 3600/" /etc/php/conf.d/upload.ini && \
    mkdir -p /etc-start/php/conf.d/ && cp -R /etc/php/conf.d/ /etc-start/php/conf.d/

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
VOLUME /var/www
CMD ["php-fpm"]
