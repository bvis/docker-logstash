#!/bin/bash -e

host="${ELASTICSEARCH_ADDR}:${ELASTICSEARCH_PORT}"

ssl=""
user=""
password=""
if [ ! -z $SSL ] && [ $SSL = true ]
then
    ssl="\nssl => true\n"
fi

if [ ! -z ${ELASTICSEARCH_PASSWORD} ] && [ ! -z ${ELASTICSEARCH_USER} ]
then
    user="\nuser => ${ELASTICSEARCH_USER}\n"
    password="\npassword => ${ELASTICSEARCH_PASSWORD}\n"
fi

cat /config-dir/70-outputs.conf | \
    sed "s/#ELASTICSEARCH#/$host/g" |\
    sed "s/#SSL#/$ssl/g" |\
    sed "s/#ELASTICSEARCH_USER#/$user/g" |\
    sed "s/#ELASTICSEARCH_PASSWORD#/$password/g" > /tmp/70-outputs.conf

mv /tmp/70-outputs.conf /config-dir/70-outputs.conf

# Add logstash as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- logstash "$@"
fi

# Run as user "logstash" if the command is "logstash"
if [ "$1" = 'logstash' ]; then
	set -- gosu logstash "$@"
fi

exec "$@"
