#!/bin/bash

HOSTADDR=0.0.0.0
BASE_DIR=/cardano
DB_PATH=${BASE_DIR}/db
SOCKET_PATH=${BASE_DIR}/socket/node.sock
CONFIG_DIR=${BASE_DIR}/config
TOPOLOGY=${CONFIG_DIR}/topology.json
CONFIG=${CONFIG_DIR}/config.json
PORT=$(cat ${CONFIG_DIR}/port.txt)
KES=${CONFIG_DIR}/kes.skey
VRF=${CONFIG_DIR}/vrf.skey
CERT=${CONFIG_DIR}/node.cert

_term() {
  echo "Stopping Cardano Producer Node ..."
  kill -SIGINT $PID
}

trap _term SIGTERM SIGINT

echo "Starting Cardano Producer Node ..."
cardano-node +RTS -N4 -RTS run --topology ${TOPOLOGY} --database-path ${DB_PATH} --socket-path ${SOCKET_PATH} --host-addr ${HOSTADDR} --port ${PORT} --config ${CONFIG} --shelley-kes-key ${KES} --shelley-vrf-key ${VRF} --shelley-operational-certificate ${CERT} &

PID=$!
wait $PID
trap - SIGTERM SIGINT
wait $PID
sleep 5
EXIT_STATUS=$?

echo "Exit Status: ${EXIT_STATUS}"