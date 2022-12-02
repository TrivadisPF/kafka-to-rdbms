#!/bin/bash

echo "removing JDBC Sink Connector"

curl -X "DELETE" "http://$DOCKER_HOST_IP:8083/connectors/jdbc-sink-connector"

echo "creating JDBC Sink Connector"

## Request
curl -X "POST" "$DOCKER_HOST_IP:8083/connectors" \
     -H "Content-Type: application/json" \
     -d $'{
  "name": "jdbc-sink-connector",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
    "tasks.max": "1",
    "topics.regex": "priv.dwh.*",
    "connection.url": "jdbc:oracle:thin:@//oracledb-xe:1521/XEPDB1",
    "connection.user": "ecomm_sales",
    "connection.password": "abc123!",
    "connection.ds.pool.size": 5,
    "quote.sql.identifiers":"never",
    "auto.create":"true",
    "auto.evolve":"false",
    "insert.mode.databaselevel": true,
    "key.converter":"org.apache.kafka.connect.storage.StringConverter",
    "key.converter.schemas.enable": "false",
    "value.converter":"io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url": "http://schema-registry-1:8081",
    "value.converter.schemas.enable": "false",
    "transforms": "route,topicCase",
    "transforms.route.regex": "priv.dwh.(.*).v1",
    "transforms.route.replacement": "$1_KC_T",
    "transforms.route.type": "org.apache.kafka.connect.transforms.RegexRouter",
    "transforms.topicCase.type": "com.github.jcustenborder.kafka.connect.transform.common.ChangeTopicCase",
    "transforms.topicCase.from": "LOWER_UNDERSCORE",
    "transforms.topicCase.to": "UPPER_UNDERSCORE"        
    }
}'

curl -X "POST" "$DOCKER_HOST_IP:8083/connectors" \
     -H "Content-Type: application/json" \
     -d $'{
  "name": "jdbc-sink-connector2",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
    "tasks.max": "1",
    "topics.regex": "pub.eshop.order-completed.event.v1",
    "connection.url": "jdbc:oracle:thin:@//oracledb-xe:1521/XEPDB1",
    "connection.user": "ecomm_sales",
    "connection.password": "abc123!",
    "connection.ds.pool.size": 5,
    "table.name.format": "ORDER_AGGR_T",
    "quote.sql.identifiers":"never",
    "auto.create":"true",
    "auto.evolve":"false",
    "insert.mode.databaselevel": true,
    "key.converter":"org.apache.kafka.connect.storage.StringConverter",
    "key.converter.schemas.enable": "false",
    "value.converter":"io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url": "http://schema-registry-1:8081",
    "value.converter.schemas.enable": "false",
    "transforms": "tojson",
    "transforms.tojson.json.string.field.name": "jsonstring",
    "transforms.tojson.type": "com.github.cedelsb.kafka.connect.smt.Record2JsonStringConverter$Value"
    }
}'
