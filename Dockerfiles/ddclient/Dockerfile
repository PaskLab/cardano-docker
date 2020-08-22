FROM ubuntu:focal
LABEL name="ddclient"
LABEL description="Client utility for dynamic DNS updates"
LABEL maintainer="https://github.com/pascallapointe"

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root

# Install DDClient
RUN apt-get update
RUN apt-get install -yq ddclient
RUN apt-get install -y libjson-any-perl
RUN apt-get install -y ca-certificates

# Add DDClient configuration, can be overridden using a 'bind mount' volume
COPY files/ddclient.conf /root/config/ddclient.conf

# Image clean-up
RUN apt-get autoremove -y
RUN apt-get clean
RUN apt-get autoclean

CMD ["ddclient", "-foreground", "-file", "/root/config/ddclient.conf"]