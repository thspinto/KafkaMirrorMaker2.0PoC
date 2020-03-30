#!/bin/bash
BOOTSTRAP_SERVER=kafka:9092

function reset_offsets() {
  local GROUP=$1
  local TOPIC=$2
  kafka-consumer-groups.sh --bootstrap-server $BOOTSTRAP_SERVER --group $GROUP --topic $TOPIC --reset-offsets --to-latest --execute
}

function main () {
  CGROUPS="$(kafka-consumer-groups.sh --bootstrap-server $BOOTSTRAP_SERVER --list)"
  IFS=$'\n'
  for GROUP in $CGROUPS
  do
    echo "Iteration on $GROUP"
    TOPICS="$(kafka-consumer-groups.sh --bootstrap-server $BOOTSTRAP_SERVER --describe --group $GROUP | tr -s ' ' | cut -d' ' -f2 | tail -n +3 | sort | uniq)"
    for TOPIC in $TOPICS
    do
      echo "Reseting $TOPIC"
      reset_offsets $GROUP $TOPIC
    done
  done
}

main
