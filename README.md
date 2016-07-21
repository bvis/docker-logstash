# Softonic Logstash

This image starts a logstash container with a basic configuration that parses syslog data in port 51415 and gelf in 12201/udp 

## Container execution

If you are using LOGSPOUT be sure that it ignores this container or you'll get an infinite loop of logging.

Be sure that the endpoint of elasticsearch is reachable by this container in the 9200 port.

    docker service create --network logging --name logstash -e LOGSPOUT=ignore logstash
