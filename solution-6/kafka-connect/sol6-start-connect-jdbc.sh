#!/bin/bash


curl -X "DELETE" "http://$DOCKER_HOST_IP:8083/connectors/sol6-jdbc-sink-connector"

curl -X "POST" "$DOCKER_HOST_IP:8083/connectors" \
     -H "Content-Type: application/json" \
     -d $'{
  "name": "sol6-jdbc-sink-connector",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
    "tasks.max": "1",
    "topics.regex": "pub.eshop.order-completed.event.v1",
    "connection.url": "jdbc:oracle:thin:@//oracledb-xe:1521/XEPDB1",
    "connection.user": "ecomm_sales",
    "connection.password": "abc123!",
    "connection.ds.pool.size": 5,
    "table.name.format": "SOL6_ORDER_AGGR_V",
    "table.types": "VIEW",
    "quote.sql.identifiers":"never",
    "auto.create":"false",
    "auto.evolve":"false",
    "pk.mode": "record_key",
    "pk.fields":"id",
    "key.converter":"org.apache.kafka.connect.storage.StringConverter",
    "key.converter.schemas.enable": "false",
    "value.converter":"io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url": "http://schema-registry-1:8081",
    "value.converter.schemas.enable": "false",
    "transforms": "ToJson,InsertField",
    "transforms.ToJson.json.string.field.name": "json_string",
    "transforms.ToJson.json.writer.output.mode": "RELAXED",
    "transforms.ToJson.type": "com.github.cedelsb.kafka.connect.smt.Record2JsonStringConverter$Value",  
    "transforms.ToJson.json.writer.handle.logical.types": "true",
    "transforms.ToJson.json.writer.datetime.logical.types.as": "STRING",
    "transforms.InsertField.type": "org.apache.kafka.connect.transforms.InsertField$Value",
    "transforms.InsertField.offset.field": "offset",
    "transforms.InsertField.timestamp.field": "timestamp",
    "transforms.InsertField.topic.field": "topicName"
    }
}'

