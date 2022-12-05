#!/bin/bash

echo "removing JDBC Sink Connector"

curl -X "DELETE" "http://$DOCKER_HOST_IP:8083/connectors/sol3-jdbc-sink-connector"

echo "creating JDBC Sink Connector"

## Request
curl -X "POST" "$DOCKER_HOST_IP:8083/connectors" \
     -H "Content-Type: application/json" \
     -d $'{
  "name": "sol3-jdbc-sink-connector",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
    "tasks.max": "1",
    "topics.regex": "sol3_priv.dwh.*",
    "connection.url": "jdbc:oracle:thin:@//oracledb-xe:1521/XEPDB1",
    "connection.user": "ecomm_sales",
    "connection.password": "abc123!",
    "connection.ds.pool.size": 5,
    "quote.sql.identifiers":"never",
    "auto.create":"true",
    "auto.evolve":"false",
    "insert.mode": "upsert",
    "pk.mode": "record_value",
    "pk.fields": "ID",
    "key.converter":"org.apache.kafka.connect.storage.StringConverter",
    "key.converter.schemas.enable": "false",
    "value.converter":"io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url": "http://schema-registry-1:8081",
    "value.converter.schemas.enable": "false",
    "transforms": "route,topicCase",
    "transforms.route.regex": "sol3_priv.dwh.(.*).v1",
    "transforms.route.replacement": "SOL3_$1_T",
    "transforms.route.type": "org.apache.kafka.connect.transforms.RegexRouter",
    "transforms.topicCase.type": "com.github.jcustenborder.kafka.connect.transform.common.ChangeTopicCase",
    "transforms.topicCase.from": "LOWER_UNDERSCORE",
    "transforms.topicCase.to": "UPPER_UNDERSCORE"        
    }
}'


