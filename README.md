# cardano-docker
Docker configurations for setting up Cardano Node Container

### Building from source 

Since we might need our binary to work on unsupported architecture like Aarch64, you'll need to build the node from the source files.
I've wrote a Dockerfile that simplify the process.

First, you need to build all required images:

        
1. The Cardano sources image (Set the right release VERSION_NUMBER, ie: `1.13.0`):

        docker build --build-arg VERSION=<VERSION_NUMBER> -t cardano_sources:latest ./Dockerfiles/sources

    ** Tip: _Add `--no-cache` to rebuild from scratch_ **

2. The node image:

        docker build -t cardano_node:latest Dockerfiles/node
        
3. The cli image:

        docker build -t cardano_cli:latest Dockerfiles/cli
                    
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
