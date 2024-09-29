# cardano-docker
Docker files for setting up Cardano Node environment.

#### You can support this repository by delegating to pool BERRY!

** **_These Dockerfiles are meant to be run along with `Docker-Compose`._**

#### !!! Support Notes !!!

* **GHC** version: **9.6.4**
* **Cabal** version: **3.10.1.0**
* Supported **cardano-node** version: **9.2.1**
* Supported **cardano-cli** version: **9.4.1.0**
* Supported **cardano-submit-api** version: **9.0.0**
* Supported **mithril** version: **2437.1**
* Supported **DBSYNC** version: **13.5.0.2**

### Building from source 

Since we need our binary to work on aarch64 architecture, you'll need to build the node from the source files.
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
   CLI_TAG=<VERSION_TAG> # only version number, omit the leading 'cardano-cli'
   ```

4. Set the output path if different from TAG

   ```bash
   # OPTIONAL / IF REQUIRED
   NODE_PATH=<PATH>
   ```      

5. The node image:

   ```bash
   docker build \
      --build-arg ARCHITECTURE=${ARCHITECTURE} \
      --build-arg NODE_TAG=${NODE_TAG} \
      --build-arg CLI_TAG=${CLI_TAG} \
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
   DBSYNC_TAG=<db-sync release tag>
   
   docker build \
      --build-arg ARCHITECTURE=${ARCHITECTURE} \
      --build-arg RELEASE=${DBSYNC_TAG} \
      -t cardano_db_sync:${DBSYNC_TAG} Dockerfiles/db-sync
   ```

8. Tag your image with the **latest** tag:

   ```bash
   docker tag cardano_node:${VERSION_NUMBER} cardano_node:latest
   ```

9. The Mithril Signer image:

   ```bash
   NODE_TAG=<VERSION_TAG>
   CLI_TAG=<VERSION_TAG>
   MITHRIL_TAG=<VERSION_TAG>
   docker build \
      --build-arg ARCHITECTURE=${ARCHITECTURE} \
      --build-arg NODE_TAG=${NODE_TAG} \
      --build-arg MITHRIL_TAG=${MITHRIL_TAG} \
      --build-arg CLI_TAG=${CLI_TAG} \
      -t mithril_signer:${MITHRIL_TAG} Dockerfiles/mithril-signer
   ```

  ** See:  [mithril.network/doc/](https://mithril.network/doc/)

10. The Mithril Relay (squid) image:

   - Edit `/Dockerfiles/squid/file/squid.conf` to add your producer internal ip address.
   - Add the configuration file in a `./squid` folder next to your `docker-compose.yml` file.

   ```bash
   docker build -t squid:latest Dockerfiles/squid
   ```

** See:  [mithril.network/doc/](https://mithril.network/doc/)

11. The Mithril Client image:

   ```bash
   MITHRIL_TAG=<VERSION_TAG>
   docker build \
      --build-arg MITHRIL_TAG=${MITHRIL_TAG} \
      -t mithril_client:${MITHRIL_TAG} Dockerfiles/mithril-client
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
        
You can find required configuration files here: 
[https://book.play.dev.cardano.org/env-mainnet.html](https://book.play.dev.cardano.org/env-mainnet.html).

Here's the files you'll need:

- `config.json`
- `topology.json`
- `byron-genesis.json` (referenced to in **config.json**)
- `shelley-genesis.json` (referenced to in **config.json**)
- `alonzo-genesis.json` (referenced to in **config.json**)
- `conway-genesis.json` (referenced to in **config.json**)

Note that a producer node will need 3 more file to run:

- `node.cert` (node operational certificat)
- `vrf.skey`
- `kes.skey`

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
