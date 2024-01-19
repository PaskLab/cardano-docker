#!/bin/bash

BASE_DIR=/cardano
SOCKET_PATH=${BASE_DIR}/socket/node.sock
CONFIG_DIR=${BASE_DIR}/config
CONFIG=${CONFIG_DIR}/mainnet-config.yaml
STATE_DIR=${BASE_DIR}/ledger-state
SCHEMA_DIR=${BASE_DIR}/schema

_term() {
  echo "Stopping Db-Sync ..."
  kill -SIGINT $PID
}

trap _term SIGTERM SIGINT

echo "Starting Db-Sync ..."
# pg_ctlcluster 12 main start
cardano-db-sync --config ${CONFIG} --socket-path ${SOCKET_PATH} --state-dir ${STATE_DIR} --schema-dir ${SCHEMA_DIR}
PID=$!
wait $PID
trap - SIGTERM SIGINT
wait $PID
sleep 5
EXIT_STATUS=$?

echo "Exit Status: ${EXIT_STATUS}"

