# cardano-docker
Docker files for setting up Cardano Node environment.

#### Reference

Many steps used in this repository are from resources bellow:

[Cardano Official Documentation](https://docs.cardano.org/projects/cardano-node/en/latest/index.html)

Thanks to everyone behind CNODE from **cardano-community repository**.

[https://github.com/cardano-community/guild-operators](https://github.com/cardano-community/guild-operators)

For non-dockerized instructions on how to compile cardano-node on RaspberryPi-4B, I'll refer you to
[Alessandro Konrad Pi-Pool repository](https://github.com/alessandrokonrad/Pi-Pool).

#### !!! Notes !!!

* The official Haskell compiler have some flaws when compiling on ARM based system. This is why the `aarch64` Dockerfile
is using the IOHK patched version of GHC. This version of GHC is not yet released as an official version so use it at your 
own risk. You can find the source code there:
   [https://github.com/input-output-hk/ghc/tree/release/8.6.5-iohk](https://github.com/input-output-hk/ghc/tree/release/8.6.5-iohk)

* All containers running on host network, providing network isolation where possible will
be part of future improvement.

### Building from source 

Since we need our binary to work on Aarch64 architecture, you'll need to build the node from the source files.
I've wrote a Dockerfile that simplify the process.

First, you need to build all required images:
  
1. Set the architecture variable to your requirement (Only x86/amd64 and aarch64 supported):
  
        ARCHITECTURE=<PROCESSOR_ARCHITECTURE(x86_64 or aarch64)>
        
2. The Cardano sources image:
        
        docker build \
            -t cardano_env:latest \
            ./Dockerfiles/build_env/${ARCHITECTURE}

    ** Tip: _Add `--no-cache` to rebuild from scratch_ **
        
3. Set the version variable (Set the right release VERSION_NUMBER, ie: `1.19.0`)

        VERSION_NUMBER=<VERSION_NUMBER>

4. The node image:

        docker build \
            --build-arg ARCHITECTURE=${ARCHITECTURE} \
            --build-arg RELEASE=${VERSION_NUMBER} \
            -t cardano_node:${VERSION_NUMBER} Dockerfiles/node
     
5. Tag your image with the **latest** tag:

        docker tag cardano_node:${VERSION_NUMBER} cardano_node:latest
                                     
### Node configuration

Now you've created yours images, it's time to create your `config` folder. Your container will bind to this folder,
so you can access your configuration from within.

    mkdir config
    cd config
        
If your OS is unix based, you can use the `wget` utility to download all configuration files from the
[official source](https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/index.html).

    wget -O config.json https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-config.json
    wget -O byron-genesis.json https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-byron-genesis.json
    wget -O shelley-genesis.json https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-shelley-genesis.json
    wget -O topology.json https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-topology.json

#### !!! Important !!!!
We rename them to `byron-genesis.json`, `shelley-genesis.json`, `topology.json` and `config.json` to avoid breaking the script every time they
change the name..! Don't forget to update the reference to the `*-genesis.json` file in your `config.json`.

#### Configuration files permissions

Your user living inside your container need to have access to your configuration file. Add public read permission to all your files under `/config`:

    chmod 644 config/*
   
#### Port configuration
        
Now, if you wish to use the `start-relay.sh` script provided in my repository, add a `port.txt` file under your `/config` 
folder. Your file should contain only one line representing the **PORT** used by your node. 
    
    echo 3000 > port.txt
    
### Relay node configuration

Now you need to configure your `topology.json` file with your Relay and Producer node information.

See: [Configure topology files for block-producing and relay nodes](https://docs.cardano.org/projects/cardano-node/en/latest/stake-pool-operations/core_relay.html).

### Creating the containers with Docker Compose

Docker Compose required `cardano_node`, `cardano_cli` and `cardano_monitor` images.
To build the `cardano_monitor` image, read: [Monitoring with Grafana](Docs/monitoring.md).

You can copy the docker-compose.yaml where your `config/` folder reside. Then start your containers with the 
following command:

    docker-compose --compatibility up -d

** Tips: To start a node as producer instead of relay, swap the comment on `CMD` line in the `docker-compose.yaml` file.
** Tips: --compatibility flag used to support deploy key.
** TIPS: Adjust limit values under deploy to your fit your system available memory to avoid OOM KILL signal.

### Read further on these topics:

- [How get peers with Topology Updater](Docs/topology.md)
- [Monitoring with Grafana](Docs/monitoring.md)
- [Installation of db-sync & graphql](../pool-monitor/Docs/db-sync.md)
- [Dynamic DNS support](Docs/dynamic_dns.md)
- [Limit containers memory usage](Docs/memory_limit.md)
- [Manually creating the containers](Docs/standalone-containers.md)
