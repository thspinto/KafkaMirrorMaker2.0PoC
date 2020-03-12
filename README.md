# Kafka Migration Tests

Kafka migration strategy tests

## Running

Start stack:
```bash
docker compose up -d
```

Run some producers:
```bash
docker-compose exec mirror kafka-verifiable-producer.sh --broker-list kafka1:9092 --throughput 1 --topic TestTopic
```

Run some consumers:
```bash
docker-compose exec mirror kafka-console-consumer.sh --bootstrap-server kafka1:9092 --group=test --topic TestTopic
```

## Debezium

To login in to mysql use

```bash
docker-compose exec mysql sh -c 'mysql -umysqluser -p'
```

Start the connector
```bash
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-mysql.json
```
Update the connector
```bash
curl -i -X PUT -H "Accept:application/json"  -H  "Content-Type:application/json" http://localhost:8083/connectors/inventory-connector/config/ -d @update-mysql.json
```

After updating the connector I was able to update Debezium's configuration pointing to the new cluster. Debezium did not loose its configuration.


## Mirror Maker 2.0

Launch with: `connect-mirror-maker.sh mm2.properties`

## Migrating consumers

* Most (if not all) consumers have offset reset set to latest. Mostly because of issues for re-consuming a topic without having idempotency on the consumers.

* Ideal strategy would be transfer the offset to the new cluster: this seams to be possible with confluences' replicator, but the license only allows to use it for 30 days.

* The other strategy would be migrating with downtime, this requires mapping the producer/consumer graph.

* Proposal migrate critical flows consumers beforehand using replication. Mass migrate the other flows updating the DNS and roll restarting the services.


## Kafka Proxy Tests

Run the producer through the proxy and put consumers on the two kafka cluster to see how a fallback the the new cluster would affect the producers.

```
docker-compose exec kafka1 kafka-verifiable-producer.sh --broker-list proxy:9092 --throughput 1 --topic TestTopic
```

It's not a good idea to use proxy to change producers/consumers to a new cluster. Consumers loose tracking of their group, producer might try to produce to the wrong broker.
