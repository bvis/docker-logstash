
output {
  if [log_type] == "request-incoming" {
    elasticsearch {
      hosts => ["#ELASTICSEARCH#"]#ELASTICSEARCH_SSL##ELASTICSEARCH_USER##ELASTICSEARCH_PASSWORD#
      index => "#ELASTICSEARCH_INDEX_PREFIX#request-incoming-%{+YYYY.MM.dd}"
    }
  }
  else if [log_type] == "request-outgoing" {
    elasticsearch {
      hosts => ["#ELASTICSEARCH#"]#ELASTICSEARCH_SSL##ELASTICSEARCH_USER##ELASTICSEARCH_PASSWORD#
      index => "#ELASTICSEARCH_INDEX_PREFIX#request-outgoing-%{+YYYY.MM.dd}"
    }
  } else if [log_type] == "docker-events" {
    elasticsearch {
      hosts => ["#ELASTICSEARCH#"]#ELASTICSEARCH_SSL##ELASTICSEARCH_USER##ELASTICSEARCH_PASSWORD#
      index => "#ELASTICSEARCH_INDEX_PREFIX#docker-events-%{+YYYY.MM.dd}"
    }
  } else if [log_type] == "alert" {
    elasticsearch {
      hosts => ["#ELASTICSEARCH#"]#ELASTICSEARCH_SSL##ELASTICSEARCH_USER##ELASTICSEARCH_PASSWORD#
      index => "#ELASTICSEARCH_INDEX_PREFIX#logstash-alerts-%{+YYYY.MM.dd}"
    }
  } else {
     elasticsearch {
        hosts => ["#ELASTICSEARCH#"]#ELASTICSEARCH_SSL##ELASTICSEARCH_USER##ELASTICSEARCH_PASSWORD#
        index => "#ELASTICSEARCH_INDEX_PREFIX#logstash-logs-%{+YYYY.MM.dd}"
     }
  }

  #DEBUG#
}
