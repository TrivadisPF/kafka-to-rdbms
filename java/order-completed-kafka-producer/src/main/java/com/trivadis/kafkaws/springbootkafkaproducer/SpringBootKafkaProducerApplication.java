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
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
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
			runProducer(1, 10);
		} else {
			runProducer(Integer.parseInt(args[0]), Integer.parseInt(args[1]));
		}

	}

	private void runProducer(int sendMessageCount, int waitMsInBetween) throws Exception {
		UUID uuid = UUID.randomUUID();
		Random random = new Random();

		for (int index = 0; index < sendMessageCount; index++) {
			List<OrderLine> orderLines = new ArrayList<>();
			orderLines.add(OrderLine.newBuilder().setLineId(1).setProductId(random.nextLong(1,2000000)).setQuantity(10).build());
			orderLines.add(OrderLine.newBuilder().setLineId(2).setProductId(random.nextLong(1,2000000)).setQuantity(5).build());
			orderLines.add(OrderLine.newBuilder().setLineId(3).setProductId(random.nextLong(1,2000000)).setQuantity(1).build());

			OrderCompletedEvent orderCompletedEvent = OrderCompletedEvent.newBuilder()
					.setOrder(
							Order.newBuilder()
									.setId(uuid)
									.setCustomerId(random.nextLong(1,2000000))
									.setOrderDate(Instant.now())
									.setOrderLines(orderLines)
									.build()
					).build();

			kafkaEventProducer.produce(uuid.toString(), orderCompletedEvent);

			// Simulate slow processing
			Thread.sleep(waitMsInBetween);

		}
	}

}
