# Topology

Peers module is currently not available, so you need to add some buddies to your
topology if you want to successfully join the network.

### First, prove yourself worthy

In order to get a peers topology file from **TopologyUpdater**, you prove that your
node is stable and up-to-date with the blockchain. The updater script is included
in the Cardano Node image. 

##### !!! Important !!!
The script use's the `genesis.json` file name. Since the combinator uses both `byron-genesis.json` and
`shelley-genesis.json`, create a copy of `shelley-genesis.json` and renamed it to `genesis.json`.

### Enable Topology Updater

If you're using docker-compose, change the env `CNODE_HOSTNAME: 'CHANGE ME'` parameters under the
`cardano_node` service for **your own domain URL**. If you're using IP's, do not touch anything.

If you're not using docker-compose, use the following command in `cardano_cli` container to activate
topologyUpdater cron job:

    docker exec -d cardano_cli start_with_topology.sh
    
You'll be able to get a topology.json file after the script made 4 successful attempt. You can
check your attempts using the following command:

    docker exec cardano_node cat /cardano/topologyUpdater_lastresult.json
    
### Get the topology.json file

Now your node have been up&running for long enough, edit the [update-topology.sh](../Scripts/update-topology.sh)
script to generate the file. Just don't forget to edit the script and change the `CUSTOM_PEERS` variable value with
your own relay ip/domain_name and IOHK relays.

**Note:** Your node need to be restarted to take a new configuration in account.
