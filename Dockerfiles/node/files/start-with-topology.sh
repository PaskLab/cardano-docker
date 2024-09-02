#!/bin/bash

HOSTADDR=0.0.0.0
BASE_DIR=/cardano
DB_PATH=${BASE_DIR}/db
SOCKET_PATH=${BASE_DIR}/socket/node.sock
CONFIG_DIR=${BASE_DIR}/config
TOPOLOGY=${CONFIG_DIR}/topology.json
CONFIG=${CONFIG_DIR}/config.json
PORT=3000

_term() {
  echo "Stopping Cardano Relay Node ..."
  kill -SIGINT $PID
}

trap _term SIGTERM SIGINT

echo "Starting Topology Updater ..."
topologyUpdater.sh &
echo "Starting Cardano Relay Node ..."
cardano-node run +RTS ${NODE_RTS} -RTS --topology ${TOPOLOGY} --database-path ${DB_PATH} --socket-path ${SOCKET_PATH} --host-addr ${HOSTADDR} --port ${PORT} --config ${CONFIG} &

PID=$!
wait $PID
trap - SIGTERM SIGINT
wait $PID
sleep 5
EXIT_STATUS=$?

echo "Exit Status: ${EXIT_STATUS}"
