FROM logstash:2

MAINTAINER Basilio Vera <basilio.vera@softonic.com>

COPY config-dir /config-dir

CMD ["-f", "/config-dir/logstash.conf"]
