# Dynamic DNS

If you don't have a static IP you still can use your dynamic's one. Providers like google
allow you to do it without any supplementary charges. Check out
[Google Dynamic DNS setup](https://support.google.com/domains/answer/6147083).

### Server side client setup

You'll need a server side client to notify your DynDNS provider for any change.
Create a `config` folder that can hold your **DDclient** configuration file and add it the 
provided configuration file

- [Dockerfiles/ddclient/files/ddclient.conf](../Dockerfiles/ddclient/files/ddclient.conf)

### Creating the DDclient image

    docker build \
        -t ddclient:latest \
        ./Dockerfiles/ddclient
            
### Creating the containers

    docker run -dit \
        --network host \
        --mount type=bind,source="$(pwd)"/config,target=/root/config \
        --name ddclient ddclient:latest
            
** Remember, you need to create your container from the repository containing your `config/` folder.