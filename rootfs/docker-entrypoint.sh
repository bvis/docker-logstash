#!/bin/bash -e

if [ -z ${ELASTICSEARCH_ADDR} ]
then
    ELASTICSEARCH_ADDR=elasticsearch
fi

if [ -z ${ELASTICSEARCH_PORT} ]
then
    ELASTICSEARCH_PORT=9200
fi

replace="${ELASTICSEARCH_ADDR}:${ELASTICSEARCH_PORT}"

if [ ! -z ${ELASTICSEARCH_PASSWORD} ] && [ ! -z ${ELASTICSEARCH_USER} ]
then
    replace="${ELASTICSEARCH_USER}:${ELASTICSEARCH_PASSWORD}${replace}"
fi

if [ ! -z ${ELASTICSEARCH_PROTOCOL} ]
then
    replace="${ELASTICSEARCH_PROTOCOL}://$replace"
fi

# Replace placeholder by environment variables
sed -i "s%#ELASTICSEARCH#%$replace%g" /config-dir/logstash.conf

cat /config-dir/logstash.conf

# Add logstash as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- logstash "$@"
fi

# Run as user "logstash" if the command is "logstash"
if [ "$1" = 'logstash' ]; then
	set -- gosu logstash "$@"
fi

exec "$@"
