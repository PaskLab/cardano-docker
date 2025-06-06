# cardano-docker
Docker files for setting up Cardano Node environment and more.

#### You can support this repository by delegating to [Berry pool [BERRY]](https://berrypool.io/) 🙏

** **_These Dockerfiles are meant to be run along with `Docker-Compose`._**

#### !!! Support Notes !!!

* **GHC** version: **9.10.2**
* **Cabal** version: **3.12.1.0**
* Supported **cardano-node** version: **10.4.1**
* Supported **cardano-cli** version: **10.11.0.0**
* Supported **cardano-submit-api** version: **10.1.1**
* Supported **mithril** version: **2517.1**
* Supported **DB-SYNC** version: **13.6.0.4**

### Building all docker images from source 

Most images are built on top of the `cardano_env:latest` images, make sure to build it first.
This image install dependencies and compilation tooling required by other images.

- [Build Environment image](#build-environment-image)
- [Cardano Node image](#cardano-node-image)
- [Submit API image](#submit-api-image)
- [DB-Sync image](#db-sync-image)
- [Mithril Signer image](#mithril-signer-image)
- [Mithril Client image](#mithril-client-image)
- [Mithril Relay (squid) image](#mithril-relay-squid-image)

#### Build Environment image

   ```bash
   ARCHITECTURE=<PROCESSOR_ARCHITECTURE(x86_64 or aarch64)>
   
   docker build \
      -t cardano_env:latest \
      ./Dockerfiles/build_env/${ARCHITECTURE}

   ``` 
    ** Tip: _Add `--no-cache` to rebuild from scratch_ **

#### Cardano Node image

   ```bash
   ARCHITECTURE=<PROCESSOR_ARCHITECTURE(x86_64 or aarch64)>
   NODE_TAG=<VERSION_TAG>
   CLI_TAG=<VERSION_TAG> # only version number, omit the leading 'cardano-cli'
   
   docker build \
      --build-arg ARCHITECTURE=${ARCHITECTURE} \
      --build-arg NODE_TAG=${NODE_TAG} \
      --build-arg CLI_TAG=${CLI_TAG} \
      -t cardano_node:${NODE_TAG} Dockerfiles/node
   ```

#### Submit API image

   ```bash
   ARCHITECTURE=<PROCESSOR_ARCHITECTURE(x86_64 or aarch64)>
   NODE_TAG=<VERSION_TAG>
   API_VERSION=<Submit API version, see cardano-submit-api.cabal file>
   
   docker build \
      --build-arg ARCHITECTURE=${ARCHITECTURE} \
      --build-arg NODE_TAG=${NODE_TAG} \
      --build-arg API_VERSION=${API_VERSION} \
      -t cardano_submit:${API_VERSION} Dockerfiles/submit
   ```

#### DB-Sync image

   ```bash
   ARCHITECTURE=<PROCESSOR_ARCHITECTURE(x86_64 or aarch64)>
   DBSYNC_TAG=<db-sync release tag>
   
   docker build \
      --build-arg ARCHITECTURE=${ARCHITECTURE} \
      --build-arg RELEASE=${DBSYNC_TAG} \
      -t cardano_db_sync:${DBSYNC_TAG} Dockerfiles/db-sync
   ```

#### Mithril Signer image

   ```bash
   ARCHITECTURE=<PROCESSOR_ARCHITECTURE(x86_64 or aarch64)>
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

#### Mithril Client image

   ```bash
   MITHRIL_TAG=<VERSION_TAG>
   
   docker build \
      --build-arg MITHRIL_TAG=${MITHRIL_TAG} \
      -t mithril_client:${MITHRIL_TAG} Dockerfiles/mithril-client
   ```

** See:  [mithril.network/doc/](https://mithril.network/doc/)

#### Mithril Relay (squid) image

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
    
### Relay node configuration

Now you need to configure your `topology.json` file with your Relay and Producer node information.

If using docker-compose, a virtual network named `cardano` will be created. This allow to isolate the block producer node
from the host network, making it reachable only by the relay nodes. You can reference them in your `topology.json` file by using
their generated hostname or the given `alias`.

Generated hostname will have the following form:

    {service name}.{project name}_{network name}

Whereas the **Project Name** is determined by the folder holding the `docker-compose.yaml` file. In our case, `/Cardano` as seen previously.

** Note that the *generated hostname* is all lowercase.

See [prometheus.yml](./Dockerfiles/monitor/files/prometheus.yml) for hostname examples.

### Creating the containers with Docker Compose

Docker Compose required `cardano_node` and `cardano_monitor` images.
To build the `cardano_monitor` image, read: [Monitoring with Grafana](Docs/monitoring.md).

You can copy the docker-compose.yaml where your `config/` folder reside. Then start your containers with the 
following command:

    docker-compose up -d

** Tips: To start a node as producer instead of relay, swap the comment on `CMD` line in the `docker-compose.yaml` file.

### Genesis peer snapshot

Genesis peer snapshot file can be updated periodically via system CRON.

```bash
# Once per week at 00:00 on Sunday
0 0 * * 0 docker exec cardano-relay cardano-cli query ledger-peer-snapshot --mainnet --out-file /cardano/config/peer-snapshot.json
```


### Read further on these topics:

- [Monitoring with Grafana](Docs/monitoring.md)
- [Dynamic DNS support](Docs/dynamic_dns.md)
- [Limit containers memory usage](Docs/memory_limit.md)
- [Manually creating the containers](Docs/standalone-containers.md)
- [Creating a db-sync snapshot](Docs/db-sync-snapshot.md)
