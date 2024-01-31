FROM alpine:3.19.1
LABEL name="ddclient"
LABEL description="Client utility for dynamic DNS updates"
LABEL maintainer="https://github.com/pascallapointe"

WORKDIR /root

# Install DDClient
RUN apk update
RUN apk add ddclient

# Add DDClient configuration, can be overridden using a 'bind mount' volume
COPY files/ddclient.conf /root/config/ddclient.conf

CMD ["ddclient", "-foreground", "-file", "/root/config/ddclient.conf"]
