#!/bin/bash

USERNAME="root"

TESTNET_MAGIC=42

CNODE_BIN="/root/.cabal/bin"
export PATH="${CNODE_BIN}:${PATH}"
export CARDANO_NODE_SOCKET_PATH="/root/node_data/socket"

SLOT_PER_PERIOD=3600
TIP=$(cardano-cli shelley query tip --testnet-magic ${TESTNET_MAGIC} | grep -oP 'SlotNo = \K\d+')
KES_PERIOD=$(expr $TIP / $SLOT_PER_PERIOD)

cardano-cli shelley node issue-op-cert --kes-verification-key-file kes.vkey --cold-signing-key-file node.skey --operational-certificate-issue-counter node.counter --kes-period $KES_PERIOD --out-file node.cert
