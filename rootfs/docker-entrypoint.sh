#!/bin/bash -e

replace="${ELASTICSEARCH_PROTOCOL}://${ELASTICSEARCH_ADDR}:${ELASTICSEARCH_PORT}"

if [ ! -z ${ELASTICSEARCH_PASSWORD} ] && [ ! -z ${ELASTICSEARCH_USER} ]
then
    replace="${ELASTICSEARCH_USER}:${ELASTICSEARCH_PASSWORD}${replace}"
fi

# Replace placeholder by environment variables
sed -i "s%#ELASTICSEARCH#%$replace%g" /config-dir/logstash.conf

# Add logstash as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- logstash "$@"
fi

# Run as user "logstash" if the command is "logstash"
if [ "$1" = 'logstash' ]; then
	set -- gosu logstash "$@"
fi

exec "$@"
