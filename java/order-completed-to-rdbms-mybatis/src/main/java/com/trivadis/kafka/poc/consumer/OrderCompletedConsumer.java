package com.trivadis.kafka.poc.consumer;

import com.trivadis.kafka.poc.avro.v1.Order;
import com.trivadis.kafka.poc.avro.v1.OrderCompletedEvent;
import com.trivadis.kafka.poc.avro.v1.OrderLine;
import com.trivadis.kafka.poc.dto.OrderDto;
import com.trivadis.kafka.poc.dto.OrderLineDto;
import com.trivadis.kafka.poc.repository.OrderCompletedRepository;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
public class OrderCompletedConsumer {
    private static final Logger LOGGER = LoggerFactory.getLogger(OrderCompletedConsumer.class);

    @Autowired
    OrderCompletedRepository orderCompletedRepository;

    @KafkaListener(topics = "${topic.name}", groupId = "simple-consumer-group")
    @Transactional
    public void receive(ConsumerRecord<Long, OrderCompletedEvent> consumerRecord) {
        OrderCompletedEvent value = consumerRecord.value();
        Long key = consumerRecord.key();
        LOGGER.info("received key = '{}' with payload='{}'", key, value);

        OrderDto orderDto = OrderDto.builder()
                    .customerId(value.getOrder().getCustomerId())
                    .orderDate(value.getOrder().getOrderDate())
                .build();
        orderCompletedRepository.insertOrder(orderDto);

        for (OrderLine orderLine : value.getOrder().getOrderLines()) {
            OrderLineDto orderLineDto = OrderLineDto.builder()
                                    .orderId(orderDto.getId())
                                    .productId(orderLine.getProductId())
                                    .quantity(orderLine.getQuantity())
                        .build();
            orderCompletedRepository.insertOrderLine(orderLineDto);
        }
    }

}
