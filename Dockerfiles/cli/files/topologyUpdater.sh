#!/bin/bash

LOG_PATH="/root/node_data"
PORT=$(cat /root/node_config/port.txt)

TESTNET_MAGIC=42

blockNo=$(cardano-cli shelley query tip --testnet-magic ${TESTNET_MAGIC} | grep -oP 'unBlockNo = \K\d+')

curl -s "https://api.clio.one/htopology/v1/?port=${PORT}&blockNo=${blockNo}&magic=${TESTNET_MAGIC}" | tee -a ${LOG_PATH}/topologyUpdater_lastresult.json
