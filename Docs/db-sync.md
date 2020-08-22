# Cardano DB Sync

### Creating images

1. Set the version variable (Set the right release VERSION_NUMBER, ie: `4.0.0`)
   
       VERSION_NUMBER=<VERSION_NUMBER>

2. Build the cardano_db_sync image:

        docker build \
            --build-arg RELEASE=${VERSION_NUMBER} \
            -t cardano_db_sync:latest ./Dockerfiles/db-sync