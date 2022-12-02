package com.trivadis.kafka.poc;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class OrderCompletedToRdbmsApplication {

	public static void main(String[] args) {
		SpringApplication.run(OrderCompletedToRdbmsApplication.class, args);
	}

}
