#!/bin/bash
set -e

if [ -z "`ls /etc/php/conf.d`" ] 
then
	cp -R /etc-start/php/conf.d/ /etc/php/conf.d
fi

exec "$@"
