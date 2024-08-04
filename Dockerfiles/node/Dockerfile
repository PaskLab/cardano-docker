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

# Add cabal config files
RUN echo 'jobs: 4\npackage cardano-crypto-praos\n  flags: +external-libsodium-vrf\n' > /root/cardano-node/cabal.project.local

# Build cardano-node binary
RUN cabal update && cabal user-config update && cabal build cardano-node --disable-tests

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

# Add cabal config files
RUN echo 'jobs: 4\npackage cardano-crypto-praos\n  flags: +external-libsodium-vrf\n' > /root/cardano-cli/cabal.project.local

# Build cardano-node binary
RUN cabal update && cabal user-config update && cabal build cardano-cli --disable-tests

RUN cp -p dist-newstyle/build/${ARCHITECTURE}-linux/${GHC_VERSION}/cardano-cli-${CLI_TAG}/x/cardano-cli/build/cardano-cli/cardano-cli /cardano/bin

# Add startup scripts
COPY files/start-relay.sh /cardano/scripts/start-relay.sh
COPY files/start-producer.sh /cardano/scripts/start-producer.sh
COPY files/start-with-topology.sh /cardano/scripts/start-with-topology.sh

# Install topologyUpdater script
# USE CURL, DO NOT UNINSTALL CURL
COPY files/topologyUpdater.sh /cardano/scripts/topologyUpdater.sh

# Creating non root user cardano
# RUN useradd -m cardano

# Add permissions
# RUN chown -R cardano:cardano /cardano
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
    libssl-dev libtinfo-dev libsystemd-dev liblmdb-dev libtool \
    zlib1g-dev llvm-14 build-essential libffi-dev automake \
    make g++ libncursesw5 jq autoconf &&\
    apt-get autoremove -y &&\
    apt-get clean &&\
    apt-get autoclean

# Switch user
# USER cardano:cardano
WORKDIR /cardano

FROM ubuntu:jammy
COPY --from=base / /

ENV PATH=/cardano/scripts:/cardano/bin:$PATH
ENV CARDANO_NODE_SOCKET_PATH=/cardano/socket/node.sock
ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

CMD ["/bin/bash", "-c", "start-relay.sh"]
