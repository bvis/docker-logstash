#!/bin/bash -e

elasticsearch_host="${ELASTICSEARCH_ADDR}:${ELASTICSEARCH_PORT}"

elasticsearch_ssl=""
elasticsearch_user=""
elasticsearch_password=""
elasticsearch_index_prefix=""
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

if [ ! -z $ELASTICSEARCH_INDEX_PREFIX ]
then
    elasticsearch_index_prefix=$ELASTICSEARCH_INDEX_PREFIX
fi

cat /opt/logstash/templates/70-outputs.conf.tpl | \
    sed "s/#DEBUG#/$debug/g" |\
    sed "s/#ELASTICSEARCH_INDEX_PREFIX#/$elasticsearch_index_prefix/g" |\
    sed "s/#ELASTICSEARCH#/$elasticsearch_host/g" |\
    sed "s/#ELASTICSEARCH_SSL#/$elasticsearch_ssl/g" |\
    sed "s/#ELASTICSEARCH_USER#/$elasticsearch_user/g" |\
    sed "s/#ELASTICSEARCH_PASSWORD#/$elasticsearch_password/g" > /tmp/70-outputs.conf

mv /tmp/70-outputs.conf /usr/share/logstash/pipeline/70-outputs.conf

exec /usr/local/bin/docker-entrypoint "$@"
