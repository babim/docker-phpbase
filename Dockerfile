FROM php:5.6-fpm
# Maintainer
# ----------
MAINTAINER babim <babim@matmagoc.com>

RUN rm -f /etc/motd && \
    echo "---" > /etc/motd && \
    echo "Support by Duc Anh Babim. Contact: ducanh.babim@yahoo.com" >> /etc/motd && \
    echo "---" >> /etc/motd && \
    touch "/(C) Babim"

# Download option
RUN apt-get update && \
    apt-get install -y wget bash && cd / && wget --no-check-certificate https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh && apt-get purge -y wget

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
	libssh2-1-dev libc-client-dev libsqlite3-dev libkrb5-dev imagemagick \
	libcurl4-openssl-dev 
#disable failed: libcurl4-dev libcurl4-gnutls-dev

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

# install oracle client extension
ENV ORACLE_VERSION 12.2.0.1.0
RUN wget http://media.matmagoc.com/oracle/instantclient-basic-linux.x64-$ORACLE_VERSION.zip && \
    wget http://media.matmagoc.com/oracle/instantclient-sdk-linux.x64-$ORACLE_VERSION.zip && \
    unzip instantclient-basic-linux.x64-$ORACLE_VERSION.zip -d /usr/local/ && \
    unzip instantclient-sdk-linux.x64-$ORACLE_VERSION.zip -d /usr/local/ && \
    ln -s /usr/local/instantclient_12_2 /usr/local/instantclient && \
    ln -s /usr/local/instantclient/libclntsh.so.12.1 /usr/local/instantclient/libclntsh.so && \
    ln -s /usr/local/instantclient/libclntshcore.so.12.1 /usr/local/instantclient/libclntshcore.so && \
    ln -s /usr/local/instantclient/libocci.so.12.1 /usr/local/instantclient/libocci.so && \
    rm -f instantclient-basic-linux.x64-$ORACLE_VERSION.zip instantclient-sdk-linux.x64-$ORACLE_VERSION.zip
ENV ORACLE_HOME /usr/local/instantclient
RUN docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/local/instantclient \
    && docker-php-ext-install oci8

#RUN cd /tmp/ && \
#    curl -O https://pecl.php.net/get/apcu-4.0.10.tgz && \
#    tar zxvf apcu-4.0.10.tgz && \
#    mkdir -p /usr/src/php/ext/apcu && mv apcu-4.0.10 /usr/src/php/ext/apcu \
#    && docker-php-ext-install -j$(nproc) apcuphpize

# install php-redis
#ENV PHPREDIS_VERSION 2.2.7
#RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz \
#    && tar xfz /tmp/redis.tar.gz \
#    && rm -r /tmp/redis.tar.gz \
#    && mv phpredis-$PHPREDIS_VERSION /usr/src/php/ext/redis \
#    && docker-php-ext-install redis

#RUN docker-php-ext-install memcached

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

RUN mkdir -p /etc-start/php/conf.d/ && cp -R /usr/local/etc/php/conf.d/* /etc-start/php/conf.d/

RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /build && \
    rm -rf /tmp/* /var/tmp/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /etc/dpkg/dpkg.cfg.d/02apt-speedup
#    cd /usr/src/php && make clean
    
ENV LC_ALL C.UTF-8
ENV TZ Asia/Ho_Chi_Minh

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9000
WORKDIR /var/www
VOLUME ["/var/www", "/usr/local/etc/php/conf.d"]
CMD ["php-fpm"]
