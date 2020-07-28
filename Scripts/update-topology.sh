#!/bin/bash
# Get peers list from CNTOOL Topology Updater

NB_PEERS=12
CUSTOM_PEERS="10.0.0.1:3001|10.0.0.2:3002|relays.mydomain.com:3003:3"
ANSWER="n"

printf "\n\nWelcome to TopologyUpdater!\n\n"

printf "!!! Do not forget to edit this script and add your own CUSTOM_PEERS !!!\n\n"

echo -e "\nDo you need a maximum of peers other than '${NB_PEERS}' ? (y/n) \c"
read ANSWER

if [ $ANSWER = "y" ]; then
    echo -e "\nEnter the required number of peers: (int) \c"
    read NB_PEERS
fi

curl -s -o topology.json "https://api.clio.one/htopology/v1/fetch/?max=${NB_PEERS}&customPeers=${CUSTOM_PEERS}"
