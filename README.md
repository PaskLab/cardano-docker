# cardano-docker
Docker configurations for setting up Cardano Node Container

### Building from source 

Since we need our binary to work on Aarch64 architecture, you'll need to build the node from the source files.
I've wrote a Dockerfile that simplify the process.

First, you need to build all required images:

        
1. The Cardano sources image (Set the right release VERSION_NUMBER, ie: `1.13.0-rewards`):

        docker build --build-arg RELEASE=<VERSION_NUMBER> -t cardano_sources:latest ./Dockerfiles/sources

    ** Tip: _Add `--no-cache` to rebuild from scratch_ **

2. The node image:

        docker build -t cardano_node:latest Dockerfiles/node
        
3. The cli image:

        docker build -t cardano_cli:latest Dockerfiles/cli
                                     
### Create config files
port.txt

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