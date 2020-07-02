#!/bin/bash

USERNAME="root" # replace nonroot with your username

CNODE_BIN="/root/.cabal/bin"
CNODE_HOME="/root/node_data"
CNODE_LOG_DIR="${CNODE_HOME}"

CNODE_PORT=$(cat /root/node_config/port.txt)  # must match your relay node port as set in the startup command
CNODE_HOSTNAME="CHANGE ME"  # optional. must resolve to the IP you are requesting from
CNODE_VALENCY=1   # optional for multi-IP hostnames

TESTNET_MAGIC=42

export PATH="${CNODE_BIN}:${PATH}"
export CARDANO_NODE_SOCKET_PATH="/root/node_data/socket"

blockNo=$(cardano-cli shelley query tip --testnet-magic $TESTNET_MAGIC | grep -oP 'unBlockNo = \K\d+')

# Note:
# if you run your node in IPv4/IPv6 dual stack network configuration and want announced the
# IPv4 address only please add the -4 parameter to the curl command below  (curl -4 -s ...)
if [ "${CNODE_HOSTNAME}" != "CHANGE ME" ]; then
  T_HOSTNAME="&hostname=${CNODE_HOSTNAME}"
else
  T_HOSTNAME=''
fi

curl -s "https://api.clio.one/htopology/v1/?port=${CNODE_PORT}&blockNo=${blockNo}&valency=${CNODE_VALENCY}&magic=${TESTNET_MAGIC}${T_HOSTNAME}" | tee -a $CNODE_LOG_DIR/topologyUpdater_lastresult.json