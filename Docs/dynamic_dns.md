# Dynamic DNS

If you don't have a static IP you still can use your dynamic's one. Providers like cloudflare
allow you to do it without any supplementary charges. Thanks to
[David Schlachter](https://www.davidschlachter.com/) for guidance:

https://www.davidschlachter.com/misc/cloudflare-ddclient.

### Server side client setup

You'll need a server side client to notify your DynDNS provider for any change.
Create a `config` folder that can hold your **DDclient** configuration file and add it the 
provided configuration file:

- [Dockerfiles/ddclient/files/ddclient.conf](../Dockerfiles/ddclient/files/ddclient.conf)

Change the configuration file access:

    sudo chown root:root ddclient.conf
    sudo chmod 400 ddclient.conf

### Creating the DDclient image

    docker build \
        -t ddclient:latest \
        ./Dockerfiles/ddclient
            
### Creating the containers

    docker run -dit \
        --mount type=bind,source="$(pwd)"/config,target=/root/config,readonly \
        --name ddclient ddclient:latest
            
** Remember, you need to create your container from the repository containing your `config/` folder.
