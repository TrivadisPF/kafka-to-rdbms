package com.trivadis.kafkaws.springbootkafkaproducer;

import com.trivadis.kafka.poc.avro.v1.OrderCompletedEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Component;

import java.time.Instant;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

@Component
public class KafkaEventProducer {
    private static final Logger LOGGER = LoggerFactory.getLogger(KafkaEventProducer.class);

    @Autowired
    private KafkaTemplate<String, OrderCompletedEvent> kafkaTemplate;

    @Value("${topic.name}")
    String kafkaTopic;

    public void produce(String key, OrderCompletedEvent orderCompletedEvent) {
        SendResult<String, OrderCompletedEvent> result = null;
        Instant timestamp = orderCompletedEvent.getOrder().getOrderDate();
        try {
            result = kafkaTemplate.send(kafkaTopic, null, timestamp.toEpochMilli(), key, orderCompletedEvent).get(10, TimeUnit.SECONDS);
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        } catch (TimeoutException e) {
            e.printStackTrace();
        }
    }
}