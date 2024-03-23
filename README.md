# cardano-docker
Docker files for setting up Cardano Node environment.

#### You can support this repository by delegating to pool BERRY!

** **_These Dockerfiles are meant to be run along with `Docker-Compose`._**

#### Reference

Many steps used in this repository are from resources bellow:

[Cardano Official Documentation](https://docs.cardano.org/projects/cardano-node/en/latest/index.html)

Thanks to everyone behind `topology updater` from **cardano-community repository**.

[https://github.com/cardano-community/guild-operators](https://github.com/cardano-community/guild-operators)

#### !!! Notes !!!

* **GHC** version: **9.6.4**
* **Cabal** version: **3.10.1.0**
* Supported **cardano-node** version: **8.7.3**
* Supported **cardano-cli** version: **8.17.0.0**
* Supported **cardano-submit-api** version: **3.2.1**

### Building from source 

Since we need our binary to work on Aarch64 architecture, you'll need to build the node from the source files.
I've written a Dockerfile that simplify the process.

First, you need to build all required images:
  
1. Set the architecture variable to your requirement (Only x86/amd64 and aarch64 supported):

    ```bash 
    ARCHITECTURE=<PROCESSOR_ARCHITECTURE(x86_64 or aarch64)>
    ```    
        
2. The Cardano sources image:

   ```bash
   docker build \
      -t cardano_env:latest \
      ./Dockerfiles/build_env/${ARCHITECTURE}

   ``` 
    ** Tip: _Add `--no-cache` to rebuild from scratch_ **


3. Set the version variable (Set the right release TAG, ie: `1.19.0`)

   ```bash
   NODE_TAG=<VERSION_TAG>
   ```

4. Set the output path if different from TAG (_CLI version now differ from node version_)

   ```bash
   # MANDATORY
   CLI_PATH=<PATH>
   
   # OPTIONAL / IF REQUIRED
   NODE_PATH=<PATH>
   ```      

5. The node image:

   ```bash
   docker build \
      --build-arg ARCHITECTURE=${ARCHITECTURE} \
      --build-arg NODE_TAG=${NODE_TAG} \
      --build-arg CLI_PATH=${CLI_PATH} \
      -t cardano_node:${NODE_TAG} Dockerfiles/node
   ```

6. The submit api image:

   ```bash
   API_VERSION=<Submit API version, see cardano-submit-api.cabal file>
   
   docker build \
      --build-arg ARCHITECTURE=${ARCHITECTURE} \
      --build-arg NODE_TAG=${NODE_TAG} \
      --build-arg API_VERSION=${API_VERSION} \
      -t cardano_submit:latest Dockerfiles/submit
   ```

7. The DB-Sync image:

   ```bash
   docker build \
      --build-arg ARCHITECTURE=${ARCHITECTURE} \
      --build-arg RELEASE=${VERSION_NUMBER} \
      -t cardano_db_sync:${VERSION_NUMBER} Dockerfiles/db-sync
   ```

8. Tag your image with the **latest** tag:

   ```bash
   docker tag cardano_node:${VERSION_NUMBER} cardano_node:latest
   ```

9. The Mithril Signer image:

   ```bash
   NODE_TAG=<VERSION_TAG>
   CLI_PATH=<PATH>
   MITHRIL_TAG=<VERSION_TAG>
   docker build \
      --build-arg ARCHITECTURE=${ARCHITECTURE} \
      --build-arg NODE_TAG=${NODE_TAG} \
      --build-arg MITHRIL_TAG=${MITHRIL_TAG} \
      --build-arg CLI_PATH=${CLI_PATH} \
      -t mithril:${MITHRIL_TAG} Dockerfiles/mithril
   ```

  ** See:  [mithril.network/doc/](https://mithril.network/doc/)

10. The Mithril Relay (squid) image:

   - Edit `/Dockerfiles/squid/file/squid.conf` to add your producer internal ip address.
   - Add the configuration file in a `./squid` folder next to your `docker-compose.yml` file.

   ```bash
   docker build -t squid:latest Dockerfiles/squid
   ```

** See:  [mithril.network/doc/](https://mithril.network/doc/)

### Folder structure

In order to have access to your node files directly on your host, we will use docker bind volumes.
This allows you to attach a folder on your host to a folder inside your node container.
They do not have to bare the same name nor the same path.

To make things simple, create the following folders structure:

    ~/Cardano/{bp|relay1|relayX}/config
    ~/Cardano/{bp|relay1|relayX}/socket
    ~/Cardano/{bp|relay1|relayX}/db
                         
** `~` is equivalent to your home folder, ie: /home/your_user_name                         
                                  
### Node configuration

Now you've created yours images, it's time to create your `config` folder, if this is not already done.
Your container will bind to this folder, so you can access your configuration from within.

    mkdir config
    cd config
        
If your OS is unix based, you can use the `wget` utility to download all configuration files from the
[official source](https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/index.html).

    wget -O config.json https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-config.json
    wget -O byron-genesis.json https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-byron-genesis.json
    wget -O shelley-genesis.json https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-shelley-genesis.json
    wget -O topology.json https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-topology.json

#### !!! Important !!!!
We rename them to `byron-genesis.json`, `shelley-genesis.json`, `topology.json` and `config.json` to make the scripts network agnostic!
Don't forget to update the reference to the `*-genesis.json` file in your `config.json`.

#### Bind folder permissions

Your user living inside your container need to have access to your configuration files and need to be able
to write in `db` and socket `folder`.
The easy way is to add public read permission to all your files under `/config`:

    chmod 644 config/*
   
The **correct** way is to give read and/or write access to the `cardano` user group. That group exists only in your 
container, but might have an equivalent (They share the same UID) group on your system.
Usually the default/first user group UID: 1000.

You can log in your container using `root` in order to change files ownership and permission:

    docker exec -it --user root cardano_node bash

You can later check on your host what is the equivalent group. All sub-folders and files under `/Cardano` folder should be
owned (in the container) by the host equivalent of the container `cardano` group to ensure that the container can write inside them.
   
#### Port configuration
        
All node are listening to the port 3000 inside the container. You can bind that port to the host port you like.

Now, if you wish to use the `start-with-topology.sh` script provided in my repository, set the `PUBLIC_PORT` environment
variable to the public port you will expose. If using docker-compose, see the provided [docker-compose.yaml](docker-compose.yaml) file.
    
### Relay node configuration

Now you need to configure your `topology.json` file with your Relay and Producer node information.

If using docker-compose, a virtual network named `cardano` will be created. This allow to isolate the block producer node
from the host network, making it reachable only by the relay nodes. You can reference them in your `topology.json` file by using
their generated hostname.

Generated hostname will have the following form:

    {service name}.{project name}_{network name}

Whereas the **Project Name** is determined by the folder holding the `docker-compose.yaml` file. In our case, `/Cardano` as seen previously.

** Note that the *generated hostname* is all lowercase.

See [prometheus.yml](./Dockerfiles/monitor/files/prometheus.yml) for hostname examples.

See: [Configure topology files for block-producing and relay nodes](https://docs.cardano.org/projects/cardano-node/en/latest/stake-pool-operations/core_relay.html).

### Creating the containers with Docker Compose

Docker Compose required `cardano_node` and `cardano_monitor` images.
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
- [Dynamic DNS support](Docs/dynamic_dns.md)
- [Limit containers memory usage](Docs/memory_limit.md)
- [Manually creating the containers](Docs/standalone-containers.md)
