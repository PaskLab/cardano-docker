# Standalone Containers

### Manually creating the containers

If you don't use docker-compose, you need to create both container by running the following commands:

    docker run -dit \
        --network host \
        --env CNODE_HOSTNAME='CHANGE ME' \
        --mount source=cardano-db,target=/cardano/db \
        --mount source=cardano-socket,target=/cardano/socket \
        --mount type=bind,source="$(pwd)"/config,target=/cardano/config,readonly \
        --name cardano_node cardano_node:latest 
            
** Remember, you need to create your container from the repository containing your `config/` folder.
** Remember, you need to change --env variable to fit your own environment