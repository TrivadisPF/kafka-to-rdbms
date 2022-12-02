# Writing data from Kafka to RDBMS (Oracle)

In this demo we will be .... 

The following diagram shows the setup of the data flow which will be implemented step by step. Of course we will not be using real-life data, but have a program simulating trucks and their driving behaviour.

![Alt Image Text](./images/use-case-overview.png "Use Case Overview")

We will see various technologies in action, such as **Kafka**, **MQTT**, **Kafka Connect**, **Kafka Streams** and **ksqlDB**.

## Preparation

The platform where the demos can be run on, has been generated using the [`platys`](http://github.com/trivadispf/platys) toolset using the [`platys-modern-data-platform`](http://github.com/trivadispf/platys-modern-data-platform) stack.

The generated artefacts are available in the `./docker` folder.

The prerequisites for running the platform are [**Docker**](https://www.docker.com/) and [**Docker Compose**](https://docs.docker.com/compose/).

The environment is completely based on docker containers. In order to easily start the multiple containers, we are going to use Docker Compose. You need to have at least 12 GB of RAM available, but better is 16 GB.

### Start the platform using Docker Compose

First, create the following two environment variables, which export the Public IP address (if a cloud environment) and the Docker Engine (Docker Host)  IP address:

``` bash
export DOCKER_HOST_IP=<docker-host-ip>
export PUBLIC_IP=<public-host-ip>
```

You can either add them to `/etc/environment` (without export) to make them persistent or use an `.env` file inside the `docker` folder with the two variables.

It is very important that these two are set, otherwise the platform will not run properly.

Now navigate into the `docker` folder and start `docker-compose`.

``` bash
cd ./docker

docker-compose up -d
```

To show all logs of all containers use

``` bash
docker-compose logs -f
```

To show only the logs for some of the containers, for example `kafka-connect-1` and `kafka-connect-2`, use

``` bash
docker-compose logs -f kafka-connect-1 kafka-connect-2
```

If you want to stop the platform (all containers), run

``` bash
docker-compose down
```

Some services in the `docker-compose.yml` are optional and can be removed, if you don't have enough resources to start them. 

As a final step, add `dataplatform` as an alias to the `/etc/hosts` file so that the links used in this document work. 

```
<public-host-ip>		dataplatform
```

If you have no rights for doing that, then you have to use your IP address instead of `dataplatform` in all the URLs.  

### Available Services 

For a list of available services, navigate to <http://dataplatform:80/services>.

When a terminal is needed, you can use the Web Terminal available at <http://dataplatform:3001/>.

### Creating the necessary Kafka Topics

The Kafka cluster is configured with `auto.topic.create.enable` set to `false`. Therefore we first have to create all the necessary topics, using the `kafka-topics` command line utility of Apache Kafka. 

From a terminal window, use the `kafka-topics` CLI inside the `kafka-1` docker container to create the topics `vehicle_tracking_` and `logisticsdb_driver `.

``` bash
docker exec -it kafka-1 kafka-topics --bootstrap-server kafka-1:19092 --create --topic vehicle_tracking_sysA --partitions 8 --replication-factor 3

docker exec -it kafka-1 kafka-topics --bootstrap-server kafka-1:19092 --create --topic vehicle_tracking_sysB --partitions 8 --replication-factor 3
```

If you don't like to work with the CLI, you can also create the Kafka topics using the graphical user interfaces [Cluster Manager for Kafka (CMAK)](http://dataplatform:28104) or the [Apache Kafka HQ (AKHQ)](http://dataplatform:28107). 

### Check logistics_db Postgresql Database

The necessary tables are created automatically when running the stack using Docker Compose. Use the following command in a terminal window, to show the content of the `driver` table:

``` bash
docker exec -ti postgresql psql -d demodb -U demo -c "SELECT * FROM logistics_db.driver"
``` 





