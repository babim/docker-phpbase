[![](https://images.microbadger.com/badges/image/babim/phpbase:5fpm.svg)](https://microbadger.com/images/babim/phpbase:5fpm "Get your own image badge on microbadger.com")[![](https://images.microbadger.com/badges/version/babim/phpbase:5fpm.svg)](https://microbadger.com/images/babim/phpbase:5fpm "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/babim/phpbase:5fpm.cron.svg)](https://microbadger.com/images/babim/phpbase:5fpm.cron "Get your own image badge on microbadger.com")[![](https://images.microbadger.com/badges/version/babim/phpbase:5fpm.cron.svg)](https://microbadger.com/images/babim/phpbase:5fpm.cron "Get your own version badge on microbadger.com")

[![](https://images.microbadger.com/badges/image/babim/phpbase:5apache.svg)](https://microbadger.com/images/babim/phpbase:5apache "Get your own image badge on microbadger.com")[![](https://images.microbadger.com/badges/version/babim/phpbase:5apache.svg)](https://microbadger.com/images/babim/phpbase:5apache "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/babim/phpbase:5apache.cron.svg)](https://microbadger.com/images/babim/phpbase:5apache.cron "Get your own image badge on microbadger.com")[![](https://images.microbadger.com/badges/version/babim/phpbase:5apache.cron.svg)](https://microbadger.com/images/babim/phpbase:5apache.cron "Get your own version badge on microbadger.com")

[![](https://images.microbadger.com/badges/image/babim/phpbase:7fpm.svg)](https://microbadger.com/images/babim/phpbase:7fpm "Get your own image badge on microbadger.com")[![](https://images.microbadger.com/badges/version/babim/phpbase:7fpm.svg)](https://microbadger.com/images/babim/phpbase:7fpm "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/babim/phpbase:7fpm.cron.svg)](https://microbadger.com/images/babim/phpbase:7fpm.cron "Get your own image badge on microbadger.com")[![](https://images.microbadger.com/badges/version/babim/phpbase:7fpm.cron.svg)](https://microbadger.com/images/babim/phpbase:7fpm.cron "Get your own version badge on microbadger.com")

[![](https://images.microbadger.com/badges/image/babim/phpbase:7apache.svg)](https://microbadger.com/images/babim/phpbase:7apache "Get your own image badge on microbadger.com")[![](https://images.microbadger.com/badges/version/babim/phpbase:7apache.svg)](https://microbadger.com/images/babim/phpbase:7apache "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/babim/phpbase:7apache.cron.svg)](https://microbadger.com/images/babim/phpbase:7apache.cron "Get your own image badge on microbadger.com")[![](https://images.microbadger.com/badges/version/babim/phpbase:7apache.cron.svg)](https://microbadger.com/images/babim/phpbase:7apache.cron "Get your own version badge on microbadger.com")

# Usage
```
docker run --name php -it -v /data/phpconfig:/usr/local/etc/php/conf.d -v /data/www:/var/www -p 80:80 babim/phpbase
```
# Volume
```
/usr/local/etc/php/conf.d
/var/www
```
Environment
```
TIMEZONE
PHP_MEMORY_LIMIT
MAX_UPLOAD
PHP_MAX_FILE_UPLOAD
PHP_MAX_POST
MAX_INPUT_TIME
MAX_EXECUTION_TIME
```
with environment ID:
```
auid = user id
agid = group id
auser = username
Default: agid = auid
```
