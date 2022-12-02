package com.trivadis.kafka.poc.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class OrderLineDto {
    private long orderId;
    private long productId;
    private int quantity;
}
