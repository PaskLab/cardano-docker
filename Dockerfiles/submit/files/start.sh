#!/bin/bash

BASE_DIR=/cardano
SOCKET_PATH=${BASE_DIR}/socket/node.sock
CONFIG_DIR=${BASE_DIR}/config
CONFIG=${CONFIG_DIR}/submit-config.yaml
PORT=3000

cardano-submit-api --config ${CONFIG} --socket-path ${SOCKET_PATH} --listen-address 0.0.0.0 --port ${PORT} --mainnet
