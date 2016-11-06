FROM php:5.6-apache
MAINTAINER "Duc Anh Babim" <ducanh.babim@yahoo.com>

RUN rm -f /etc/motd && \
    echo "---" > /etc/motd && \
    echo "Support by Duc Anh Babim. Contact: ducanh.babim@yahoo.com" >> /etc/motd && \
    echo "---" >> /etc/motd && \
    touch "/(C) Babim"

RUN apt-get update && apt-get install -y locales \
	unzip apt-utils git openssl curl wget \
	libbz2-dev libxslt-dev libpq-dev libmemcached-dev libicu-dev libmcrypt-dev \
	g++ libfreetype6-dev libfreetype6 libjpeg62-turbo libjpeg62-turbo-dev \
	libpng12-dev libpng12-0 libssl-dev libxml2-dev libzzip-dev \
	libjpeg-dev libldap2-dev zlib1g-dev libssl-dev bison librecode-dev \
	libreadline-dev libpspell-dev libmcrypt4 libenchant-dev firebird2.5-dev \
	libtidy-dev libgmp-dev libxslt1-dev libsnmp-dev freetds-dev unixodbc-dev \
	libpcre3-dev libsasl2-dev libmhash-dev libxpm-dev libgd2-xpm-dev \
	re2c file libpng3 libpng++-dev libvpx-dev libgd-dev libmagic-dev libexif-dev \
	libssh2-1-dev libc-client-dev libsqlite3-dev libkrb5-dev imagemagick
#disable failed libcurl4-gnutls-dev libcurl4-openssl-dev libcurl3-dev

RUN docker-php-ext-configure gd --enable-gd-native-ttf \
	--with-png-dir=/usr --with-jpeg-dir=/usr \
	--with-freetype-dir=/usr/lib/x86_64-linux-gnu \
	&& docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
	&& docker-php-ext-configure bcmath \
	&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu

RUN docker-php-ext-install bcmath bz2 calendar enchant ctype dba dom exif fileinfo \
	ldap ftp gd gettext hash iconv mbstring mcrypt mysqli pgsql posix pdo pdo_mysql \
	pdo_pgsql pdo_sqlite intl json pspell shmop soap sockets wddx interbase \
	xmlwriter opcache phar session simplexml tokenizer xml xmlrpc xsl zip tidy \
	imap xmlreader
#disable failed sqlite3 curl

RUN pecl install -f APCu-4.0.10 mongo redis memcached && \
	docker-php-ext-enable apcu redis memcached

# Install Composer for Laravel
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

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
# set upload and timezone tweak
RUN { \
		echo 'display_errors = On'; \
		echo 'date.timezone = "Asia/Ho_Chi_Minh"'; \
		echo 'cgi.fix_pathinfo=0'; \
		echo 'upload_max_filesize = 520M'; \
		echo 'post_max_size = 520M'; \
		echo 'max_input_time = 3600'; \
		echo 'max_execution_time = 3600'; \
	} > /usr/local/etc/php/conf.d/babim.ini

RUN dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8

RUN a2enmod rewrite && \
    a2enmod expires && \
    a2enmod mime && \
    a2enmod filter && \
    a2enmod deflate
    
RUN mkdir -p /etc-start/php/conf.d/ && cp -R /usr/local/etc/php/conf.d/* /etc-start/php/conf.d/

RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /build && \
    rm -rf /tmp/* /var/tmp/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    cd /usr/src/php && make clean
    
ENV LC_ALL C.UTF-8
ENV TZ Asia/Ho_Chi_Minh

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80
WORKDIR /var/www
VOLUME ["/var/www", "/usr/local/etc/php/conf.d"]
CMD ["apache2-foreground"]
