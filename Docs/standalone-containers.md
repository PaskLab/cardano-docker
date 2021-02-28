# Standalone Containers

### Manually creating the containers

If you don't use docker-compose, you need to create both container by running the following commands:

    docker run -dit \
        --network host \
        --env CNODE_HOSTNAME='CHANGE ME' \
        --mount type=bind,source="$(pwd)"/db,target=/cardano/db \
        --mount type=bind,source="$(pwd)"/socket,target=/cardano/socket \
        --mount type=bind,source="$(pwd)"/config,target=/cardano/config,readonly \
        --name cardano_node cardano_node:latest 
            
** Remember, you need to create your container from the repository containing your `config/`,
 `socket` and `db` folder.
** Remember, you need to change --env variable to fit your own environment