package com.trivadis.kafka.poc.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@Setter
@Getter
@Builder
public class OrderDto {
    private long id;
    private long customerId;
    private Instant orderDate;

    private List<OrderLineDto> orderLines = new ArrayList<>();
}
