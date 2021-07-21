#!/bin/bash

HOSTADDR=0.0.0.0
BASE_DIR=/cardano
DB_PATH=${BASE_DIR}/db
SOCKET_PATH=${BASE_DIR}/socket/node.sock
CONFIG_DIR=${BASE_DIR}/config
TOPOLOGY=${CONFIG_DIR}/topology.json
CONFIG=${CONFIG_DIR}/config.json
PORT=$(cat ${CONFIG_DIR}/port.txt)

_term() {
  echo "Stopping Cardano Relay Node ..."
  kill -SIGINT $PID
}

echo "Starting Cardano Relay Node ..."
cardano-node run +RTS -N4 --disable-delayed-os-memory-return -I0.3 -Iw600 -A16m -F1.5 -H2500M -RTS --topology ${TOPOLOGY} --database-path ${DB_PATH} --socket-path ${SOCKET_PATH} --host-addr ${HOSTADDR} --port ${PORT} --config ${CONFIG} &

PID=$!
wait $PID
trap _term SIGTERM SIGINT
wait $PID
sleep 5
EXIT_STATUS=$?

echo "Exit Status: ${EXIT_STATUS}"