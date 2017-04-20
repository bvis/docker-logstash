#!/bin/bash -e

elasticsearch_host="${ELASTICSEARCH_ADDR}:${ELASTICSEARCH_PORT}"

elasticsearch_ssl=""
elasticsearch_user=""
elasticsearch_password=""
debug=""

if [ ! -z $ELASTICSEARCH_SSL ] && [ $ELASTICSEARCH_SSL = true ]
then
    elasticsearch_ssl="\n        ssl => true\n"
fi

if [ ! -z ${ELASTICSEARCH_PASSWORD} ] && [ ! -z ${ELASTICSEARCH_USER} ]
then
    elasticsearch_user="\n        user => ${ELASTICSEARCH_USER}\n"
    elasticsearch_password="\n        password => ${ELASTICSEARCH_PASSWORD}\n"
fi

if [ ! -z $DEBUG ] && [ $DEBUG = true ]
then
    debug="stdout { codec => rubydebug }\n"
fi

cat /opt/logstash/templates/70-outputs.conf.tpl | \
    sed "s/#DEBUG#/$debug/g" |\
    sed "s/#ELASTICSEARCH#/$elasticsearch_host/g" |\
    sed "s/#ELASTICSEARCH_SSL#/$elasticsearch_ssl/g" |\
    sed "s/#ELASTICSEARCH_USER#/$elasticsearch_user/g" |\
    sed "s/#ELASTICSEARCH_PASSWORD#/$elasticsearch_password/g" > /tmp/70-outputs.conf

mv /tmp/70-outputs.conf /config-dir/70-outputs.conf

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- logstash "$@"
fi

# Run as user "logstash" if the command is "logstash"
# allow the container to be started with `--user`
if [ "$1" = 'logstash' -a "$(id -u)" = '0' ]; then
	set -- su-exec logstash "$@"
fi

exec "$@"
