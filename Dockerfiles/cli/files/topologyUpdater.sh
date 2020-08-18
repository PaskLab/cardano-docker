#!/bin/bash

# Adapted version of the script provided by CNTOOL
# https://cardano-community.github.io/guild-operators/Scripts/topologyupdater.html

# shellcheck disable=SC2086,SC2034

USERNAME="${NON_ROOT_USERNAME}" # replace with your username

CNODE_BIN="/root/.cabal/bin"
CNODE_DATA_DIR="/root/node_data"
CNODE_CONFIG_DIR="/root/node_config"
CNODE_LOG_DIR="${CNODE_DATA_DIR}"

CNODE_PORT=$(cat /root/node_config/port.txt)  # must match your relay node port as set in the startup command
CNODE_HOSTNAME=${CNODE_HOSTNAME:-'CHANGE ME'}
CNODE_VALENCY=1   # optional for multi-IP hostnames

if [ "${CNODE_HOSTNAME}" != "CHANGE ME" ]; then
  T_HOSTNAME="&hostname=${CNODE_HOSTNAME}"
else
  T_HOSTNAME=''
fi

# Adapting cardano-cli command for the network
CONFIG_JSON="${CNODE_CONFIG_DIR}/config.json"
GENESIS_JSON="${CNODE_CONFIG_DIR}/genesis.json"

PROTOCOL=$(grep -E '^.{0,1}Protocol.{0,1}:' "${CONFIG_JSON}" | tr -d '"' | tr -d ',' | awk '{print $2}')
if [[ "${PROTOCOL}" = "Cardano" ]]; then
  PROTOCOL_IDENTIFIER="--cardano-mode"
fi

NETWORKID=$(jq -r .networkId $GENESIS_JSON)
NWMAGIC=$(jq -r .networkMagic < $GENESIS_JSON)
[[ "${NWMAGIC}" = "764824073" ]] && NETWORK_IDENTIFIER="--mainnet" || NETWORK_IDENTIFIER="--testnet-magic ${NWMAGIC}"

export PATH="${CNODE_BIN}:${PATH}"
export CARDANO_NODE_SOCKET_PATH="/root/node_data/socket"

blockNo=$(cardano-cli shelley query tip ${PROTOCOL_IDENTIFIER} ${NETWORK_IDENTIFIER} | jq -r .blockNo )

curl -s "https://api.clio.one/htopology/v1/?port=${CNODE_PORT}&blockNo=${blockNo}&valency=${CNODE_VALENCY}&magic=${NWMAGIC}${T_HOSTNAME}" | tee -a $CNODE_LOG_DIR/topologyUpdater_lastresult.json
