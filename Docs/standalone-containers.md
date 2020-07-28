# Standalone Containers

### Manually creating the containers

If you don't use docker-compose, you need to create both container by running the following commands:

    docker run -dit \
        --network host \
        --mount source=cardano-node,target=/root/node_data \
        --mount type=bind,source="$(pwd)"/config,target=/root/node_config \
        --name cardano_node cardano_node:latest 

    docker run -dit \
        --network host \
        --mount source=cardano-node,target=/root/node_data \
        --mount type=bind,source="$(pwd)"/config,target=/root/node_config \
        --name cardano_cli cardano_cli:latest
            
** Remember, you need to create container from the repository containing your `config/` folder.