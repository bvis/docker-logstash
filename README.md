# Softonic Logstash

This image starts a logstash container with a basic configuration that parses syslog data in port 51415 and gelf in 12201/udp 

## Container execution

If you are using LOGSPOUT be sure that it ignores this container or you'll get an infinite loop of logging.

By default it tries to send the logs to the Elasticsearch on the address "elasticsearch:9200".

    docker service create \
      --name logstash \
      -e LOGSPOUT=ignore \
      basi/logstash
    
This can be changed using the environment variables:

- ELASTICSEARCH_ADDR
- ELASTICSEARCH_PORT
- ELASTICSEARCH_PROTOCOL  (optional)
- ELASTICSEARCH_USER      (optional)
- ELASTICSEARCH_PASSWORD  (optional)

For example:

    docker service create \
      --name logstash \
      -e LOGSPOUT=ignore \
      -e ELASTICSEARCH_PROTOCOL=https \
      -e ELASTICSEARCH_USER=user \
      -e ELASTICSEARCH_PASSWORD=password \
      -e ELASTICSEARCH_ADDR=myelastic.example.com \
      -e ELASTICSEARCH_PORT=9201 \
      basi/logstash
