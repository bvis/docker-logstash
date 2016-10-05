#!/bin/bash -e

# Replace placeholder by environment variables
sed -i "s@#ELASTICSEARCH#@${ELASTICSEARCH_ADDR}:${ELASTICSEARCH_PORT}@g" /config-dir/logstash.conf

# Add logstash as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- logstash "$@"
fi

# Run as user "logstash" if the command is "logstash"
if [ "$1" = 'logstash' ]; then
	set -- gosu logstash "$@"
fi

exec "$@"
