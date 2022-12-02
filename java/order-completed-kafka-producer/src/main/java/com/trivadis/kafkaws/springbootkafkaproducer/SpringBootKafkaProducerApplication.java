package com.trivadis.kafkaws.springbootkafkaproducer;

import com.trivadis.kafka.poc.avro.v1.Order;
import com.trivadis.kafka.poc.avro.v1.OrderCompletedEvent;
import com.trivadis.kafka.poc.avro.v1.OrderCompletedEventProtocol;
import com.trivadis.kafka.poc.avro.v1.OrderLine;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.time.Instant;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@SpringBootApplication
public class SpringBootKafkaProducerApplication implements CommandLineRunner {

	private static Logger LOG = LoggerFactory.getLogger(SpringBootKafkaProducerApplication.class);

	@Autowired
	private KafkaEventProducer kafkaEventProducer;

	public static void main(String[] args) {
		SpringApplication.run(SpringBootKafkaProducerApplication.class, args);
	}

	@Override
	public void run(String... args) throws Exception {
		LOG.info("EXECUTING : command line runner");

		if (args.length == 0) {
			runProducer(1, 10, 0);
		} else {
			runProducer(Integer.parseInt(args[0]), Integer.parseInt(args[1]), Long.parseLong(args[2]));
		}

	}

	private void runProducer(int sendMessageCount, int waitMsInBetween, long id) throws Exception {
		Long key = (id > 0) ? id : null;

		for (int index = 0; index < sendMessageCount; index++) {
			List<OrderLine> orderLines = new ArrayList<>();
			orderLines.add(OrderLine.newBuilder().setLineId(1).setProductId(12).setQuantity(10).build());
			orderLines.add(OrderLine.newBuilder().setLineId(2).setProductId(20).setQuantity(5).build());
			orderLines.add(OrderLine.newBuilder().setLineId(3).setProductId(10).setQuantity(1).build());

			OrderCompletedEvent orderCompletedEvent = OrderCompletedEvent.newBuilder()
					.setOrder(
							Order.newBuilder()
									.setGuid(UUID.randomUUID())
									.setId(id)
									.setCustomerId(2)
									.setOrderDate(Instant.now())
									.setOrderLines(orderLines).build()
					).build();

			kafkaEventProducer.produce(index, key, orderCompletedEvent);

			// Simulate slow processing
			Thread.sleep(waitMsInBetween);

		}
	}

}
