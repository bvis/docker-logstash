FROM logstash:2

MAINTAINER Basilio Vera <basilio.vera@softonic.com>

ENV "ELASTICSEARCH_ADDR=elasticsearch" \
    "ELASTICSEARCH_PORT=9200"

ADD rootfs /

CMD ["-f", "/config-dir/"]
