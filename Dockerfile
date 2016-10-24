FROM logstash:2

MAINTAINER Basilio Vera <basilio.vera@softonic.com>

ENV "ELASTICSEARCH_ADDR=elasticsearch" \
    "ELASTICSEARCH_PORT=9200"

# Instead of a single "ADD rootfs /" command to avoid the bug: https://github.com/docker/hub-feedback/issues/811
ADD rootfs/config-dir /config-dir
ADD rootfs/opt /opt
ADD rootfs/docker-entrypoint.sh /docker-entrypoint.sh

CMD ["-f", "/config-dir/"]
