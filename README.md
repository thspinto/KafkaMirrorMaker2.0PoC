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
docker-compose exec mirror kafka-verifiable-consumer.sh --broker-list kafka1:9092 --group-instance-id=test --group-id=test --topic TestTopic
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
curl -i -X PUT -H "Accept:application/json"  -H  "Content-Type:application/json" https://localhost:8083/connectors/inventory-connector/config/ -d @update-mysql.json
```

After updating the connector I was able to update Debezium's configuration pointing to the new cluster. Debeium did not loose its configuration.


## Mirror Maker 2.0

Launch with: `connect-mirror-maker.sh mm2.properties`
