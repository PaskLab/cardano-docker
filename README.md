# cardano-docker
Docker configurations for setting up Cardano Node Container

### Building from source 

Since we need our binary to work on Aarch64 architecture, you'll need to build the node from the source files.
I've wrote a Dockerfile that simplify the process.

First, you need to build all required images:

        
1. The Cardano sources image (Set the right release VERSION_NUMBER, ie: `1.13.0-rewards`):

        VERSION_NUMBER=<VERSION_NUMBER>; \
            docker build \
            --build-arg RELEASE=${VERSION_NUMBER} \
            -t cardano_sources:${VERSION_NUMBER} \
            ./Dockerfiles/sources

    ** Tip: _Add `--no-cache` to rebuild from scratch_ **

2. Tag the `cardano_sources` image as **latest**:

        docker tag cardano_sources:${VERSION_NUMBER} cardano_sources:latest

3. The node image:

        docker build -t cardano_node:${VERSION_NUMBER} Dockerfiles/node
        
4. The cli image:

        docker build -t cardano_cli:${VERSION_NUMBER} Dockerfiles/cli
        
5. Tag your images with the **latest** tag:

        docker tag cardano_node:${VERSION_NUMBER} cardano_node:latest
        docker tag cardano_cli:${VERSION_NUMBER} cardano_cli:latest
                                     
### Node configuration

Now you've created yours images, it's time to create your `config` folder. Your container will bind to this folder,
so you can access your configuration from within.

    mkdir config
    cd config
        
If your OS is unix based, you can use the `wget` utility to download all configuration files from the
[official source](https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/index.html).

    wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/ff-topology.json
    wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/ff-genesis.json
    wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/ff-config.json
        
Now, if you wish to use the `start-relay.sh` script provided in my repository, add a `port.txt` file under your `/config` 
folder. Your file should contain only one line representing the **PORT** used by your node. 
    
    echo 3000 > port.txt
    
#### Relay node configuration



### Creating the container

Next, you need to create both container by running the following commands:

    docker run -dit \
        --network host \
        --mount source=cardano_node,target=/node_data \
        --mount type=bind,source="$(pwd)"/config,target=/node_config \
        --name cardano_node cardano_node:latest 

    docker run -dit \
        --network host \
        --mount source=cardano_node,target=/node_data \
        --mount type=bind,source="$(pwd)"/config,target=/node_config \
        --name cardano_cli cardano_cli:latest
            
** Remember, you need to create container from the repository containing your `config/` folder.

### Start a relay node

    cardano-node run \
       --topology /node_config/ff-topology.json \
       --database-path /node_data \
       --socket-path /node_data/node.socket \
       --port 3000 \
       --config /node_config/ff-config.json 

[]: https://hydra.iohk.io/build/2735165/download/1/index.html