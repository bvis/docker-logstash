# Softonic Logstash

[![](https://images.microbadger.com/badges/image/basi/logstash.svg)](https://microbadger.com/images/basi/logstash "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/basi/logstash.svg)](https://microbadger.com/images/basi/logstash "Get your own version badge on microbadger.com")

This image starts a logstash container with a basic configuration that parses:
 
- JSON (e.g. for Logspout) in port 5000 (TCP and UDP)
- syslog data in port 51415
- gelf in port 12201/udp
- beats in port 51044
- http in port 8080

## Container execution

If you are using LOGSPOUT be sure that it ignores this container or you'll get an infinite loop of logging.

By default it tries to send the logs to the Elasticsearch on the address "elasticsearch:9200".

    docker service create \
      --name logstash \
      -e LOGSPOUT=ignore \
      basi/logstash

The default configuration assumes that the Elasticsearch server is in the address ```http://elasticsearch:9200```, without user/pass.

This can be changed using the environment variables:

- DEBUG
- ELASTICSEARCH_ADDR
- ELASTICSEARCH_PORT
- ELASTICSEARCH_SSL
- ELASTICSEARCH_USER
- ELASTICSEARCH_PASSWORD
- ELASTICSEARCH_INDEX_PREFIX

For example:

    docker service create \
      --name logstash \
      -e DEBUG=false \
      -e LOGSPOUT=ignore \
      -e ELASTICSEARCH_SSL=true \
      -e ELASTICSEARCH_USER=user \
      -e ELASTICSEARCH_PASSWORD=password \
      -e ELASTICSEARCH_ADDR=myelastic.example.com \
      -e ELASTICSEARCH_PORT=9201 \
      -e ELASTICSEARCH_INDEX_PREFIX="swarm-" \
      basi/logstash

