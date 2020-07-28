FROM ubuntu:focal
LABEL name="ddclient"
LABEL description="Client utility for dynamic DNS updates"
LABEL maintainer="https://github.com/pascallapointe"

ENV DEBIAN_FRONTEND=noninteractive

# Install DDClient
RUN apt-get update
RUN apt-get install -yq ddclient