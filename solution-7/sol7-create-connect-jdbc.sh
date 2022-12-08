#!/bin/bash


curl -X "DELETE" "http://$DOCKER_HOST_IP:8083/connectors/sol7-jdbc-sink-connector"

curl -X "POST" "$DOCKER_HOST_IP:8083/connectors" \
     -H "Content-Type: application/json" \
     -d $'{
  "name": "sol7-jdbc-sink-connector",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
    "tasks.max": "1",
    "topics.regex": "pub.eshop.order-completed.event.v1",
    "connection.url": "jdbc:oracle:thin:@//oracledb-xe:1521/XEPDB1",
    "connection.user": "ecomm_sales",
    "connection.password": "abc123!",
    "connection.ds.pool.size": 5,
    "table.name.format": "SOL7_ORDER_AGGR_T",
    "table.types": "TABLE",
    "quote.sql.identifiers":"never",
    "auto.create":"false",
    "auto.evolve":"false",
    "insert.mode": "upsert",
    "pk.mode": "kafka",
    "pk.fields":"topic,partition,offset",
    "db.timezone": "UTC",
    "key.converter":"org.apache.kafka.connect.storage.StringConverter",
    "key.converter.schemas.enable": "false",
    "value.converter":"io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url": "http://schema-registry-1:8081",
    "value.converter.schemas.enable": "false",
    "transforms": "ToJson,InsertField,AddTimestamp",
    "transforms.ToJson.json.string.field.name": "json_string",
    "transforms.ToJson.json.writer.output.mode": "RELAXED",
    "transforms.ToJson.type": "com.github.cedelsb.kafka.connect.smt.Record2JsonStringConverter$Value",  
    "transforms.ToJson.json.writer.handle.logical.types": "true",
    "transforms.ToJson.json.writer.datetime.logical.types.as": "STRING",
    "transforms.InsertField.type": "org.apache.kafka.connect.transforms.InsertField$Value",
    "transforms.InsertField.timestamp.field": "timestamp",
    "transforms.AddTimestamp.type" : "com.github.jcustenborder.kafka.connect.transform.common.TimestampNowField$Value",
    "transforms.AddTimestamp.fields" : "created_date"    
    }
}'

