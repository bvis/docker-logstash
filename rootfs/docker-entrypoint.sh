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

echo "
input {
  # Listens on 514/udp and 514/tcp by default; change that to non-privileged port
  syslog { port => 51415 }
  # Default port is 12201/udp
  gelf { }
  # This generates one test event per minute.
  # It is great for debugging, but you might
  # want to remove it in production.
  heartbeat { }
}
# The following filter is a hack!
# The \"de_dot\" filter would be better, but it
# is not pre-installed with logstash by default.
filter {
  ruby {
    code => \"
      event.to_hash.keys.each { |k| event[ k.gsub('.','_') ] = event.remove(k) if k.include?'.' }
    \"
  }
}
output {
  elasticsearch {
    hosts => [\"#ELASTICSEARCH#\"]#SSL##ELASTICSEARCH_USER##ELASTICSEARCH_PASSWORD#
  }
  # This will output every message on stdout.
  # It is great when testing your setup, but in
  # production, it will probably cause problems;
  # either by filling up your disks, or worse,
  # by creating logging loops! BEWARE!
  stdout {
    codec => rubydebug
  }
}
" | \
    sed "s/#ELASTICSEARCH#/$host/g" |\
    sed "s/#SSL#/$ssl/" |\
    sed "s/#ELASTICSEARCH_USER#/$user/g" |\
    sed "s/#ELASTICSEARCH_PASSWORD#/$password/g" > /config-dir/logstash.conf

# Add logstash as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- logstash "$@"
fi

# Run as user "logstash" if the command is "logstash"
if [ "$1" = 'logstash' ]; then
	set -- gosu logstash "$@"
fi

exec "$@"
