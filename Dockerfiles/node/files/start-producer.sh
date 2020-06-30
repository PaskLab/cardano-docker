#!/bin/sh

HOSTADDR=0.0.0.0
DATA_DIR=/root/node_data
CONFIG_DIR=/root/node_config
TOPOLOGY=${CONFIG_DIR}/shelley_testnet-topology.json
DB_PATH=${DATA_DIR}/db
SOCKET_PATH=${DATA_DIR}/socket
CONFIG=${CONFIG_DIR}/shelley_testnet-config.json
PORT=$(cat ${CONFIG_DIR}/port.txt)
KES=${CONFIG_DIR}/kes.skey
VRF=${CONFIG_DIR}/vrf.skey
CERT=${CONFIG_DIR}/node.cert

cardano-node run --topology ${TOPOLOGY} --database-path ${DB_PATH} --socket-path ${SOCKET_PATH} --host-addr ${HOSTADDR} --port ${PORT} --config ${CONFIG} --shelley-kes-key ${KES} --shelley-vrf-key ${VRF} --shelley-operational-certificate ${CERT}
