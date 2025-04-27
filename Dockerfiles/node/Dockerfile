FROM cardano_env AS base

LABEL name="cardano_node"
LABEL description="Cardano node"
LABEL maintainer="https://github.com/pascallapointe"

WORKDIR /root

# Download cardano-node repository
ARG NODE_TAG
RUN git clone https://github.com/IntersectMBO/cardano-node.git
WORKDIR /root/cardano-node
RUN git checkout ${NODE_TAG} && git submodule update --init --recursive

# Build cardano-node binary
RUN cabal update && cabal build cardano-node --disable-tests

# Create files structure
ARG GHC_VERSION=ghc-9.6.4
ARG NODE_PATH=$NODE_TAG
ARG ARCHITECTURE
RUN mkdir -p /cardano/config /cardano/bin /cardano/db /cardano/socket /cardano/scripts &&\
    cp -p dist-newstyle/build/${ARCHITECTURE}-linux/${GHC_VERSION}/cardano-node-${NODE_PATH}/x/cardano-node/build/cardano-node/cardano-node /cardano/bin

WORKDIR /root

# Download cardano-cli repository
ARG CLI_TAG
RUN git clone https://github.com/IntersectMBO/cardano-cli.git
WORKDIR /root/cardano-cli
RUN git checkout cardano-cli-${CLI_TAG} && git submodule update --init --recursive

# Build cardano-cli binary
RUN cabal update && cabal build cardano-cli --disable-tests

RUN cp -p dist-newstyle/build/${ARCHITECTURE}-linux/${GHC_VERSION}/cardano-cli-${CLI_TAG}/x/cardano-cli/build/cardano-cli/cardano-cli /cardano/bin

# Add startup scripts
COPY files/start-relay.sh /cardano/scripts/start-relay.sh
COPY files/start-producer.sh /cardano/scripts/start-producer.sh

# Add permissions
RUN chmod g+s /cardano && chmod 540 /cardano/scripts/* && chmod 540 /cardano/bin/*

# Image clean-up
WORKDIR /root

RUN cabal clean &&\
    rm -rf cardano-node &&\
    rm -rf cardano-cli &&\
    ./ghcup nuke &&\
    rm -rf .cabal .local .ghcup .ghc .cache ghcup &&\
    rustup self uninstall -y &&\
    apt-get purge -y apt-utils git wget pkg-config libgmp-dev \
        libssl-dev libtinfo-dev libsystemd-dev libtool \
        zlib1g-dev llvm-dev build-essential libffi-dev automake \
        make g++ libncursesw5 jq autoconf &&\
    apt-get autoremove -y &&\
    apt-get clean &&\
    apt-get autoclean

FROM ubuntu:jammy
COPY --from=base / /

ENV PATH=/cardano/scripts:/cardano/bin:$PATH
ENV CARDANO_NODE_SOCKET_PATH=/cardano/socket/node.sock
ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

WORKDIR /cardano

CMD ["/bin/bash", "-c", "start-relay.sh"]
