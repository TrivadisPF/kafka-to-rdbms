package com.trivadis.kafka.poc.repository;

import com.trivadis.kafka.poc.dto.OrderDto;
import com.trivadis.kafka.poc.dto.OrderLineDto;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;

@Mapper
public interface OrderCompletedRepository {

    @Insert("INSERT INTO order_t (id, customer_id, order_date) " +
            "VALUES (order_seq.NEXTVAL, #{customerId}, #{orderDate} )")
    @Options(useGeneratedKeys = true, keyColumn = "id", keyProperty = "id")
    int insertOrder(OrderDto orderDto);


    @Insert("INSERT INTO order_line_t (id, order_id, product_id, quantity) " +
            "VALUES (order_line_seq.NEXTVAL, #{orderId}, #{productId}, #{quantity} )")
    int insertOrderLine(OrderLineDto orderLineDto);
}


