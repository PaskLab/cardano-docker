FROM cardano_env

LABEL name="cardano_node"
LABEL description="Cardano node"
LABEL maintainer="https://github.com/pascallapointe"

WORKDIR /root

# Download cardano-node repository
ARG RELEASE
ARG ARCHITECTURE
ARG GHC_VERSION=ghc-8.10.7
RUN git clone https://github.com/input-output-hk/cardano-node
WORKDIR /root/cardano-node
RUN git checkout ${RELEASE}
RUN git submodule update --init --recursive

# Add cabal config files
COPY files/cabal.project.local /root/cardano-node/cabal.project.local

# Build cardano-node binary
RUN cabal update
RUN cabal user-config update
RUN cabal build all

# Create files structure
RUN mkdir -p /cardano/config /cardano/bin /cardano/db /cardano/socket /cardano/scripts
ARG RELEASE_PATH=$RELEASE
RUN cp -p dist-newstyle/build/${ARCHITECTURE}-linux/${GHC_VERSION}/cardano-node-${RELEASE_PATH}/x/cardano-node/build/cardano-node/cardano-node /cardano/bin
RUN cp -p dist-newstyle/build/${ARCHITECTURE}-linux/${GHC_VERSION}/cardano-cli-${RELEASE_PATH}/x/cardano-cli/build/cardano-cli/cardano-cli /cardano/bin

# Add startup scripts
COPY files/start-relay.sh /cardano/scripts/start-relay.sh
COPY files/start-producer.sh /cardano/scripts/start-producer.sh
COPY files/start-with-topology.sh /cardano/scripts/start-with-topology.sh

# Install topologyUpdater script
RUN apt-get update
RUN apt-get install -y curl
COPY files/topologyUpdater.sh /cardano/scripts/topologyUpdater.sh

# Creating non root user cardano
RUN useradd -m cardano

# Add permissions
RUN chown -R cardano:cardano /cardano
RUN chmod g+s /cardano
RUN chmod 540 /cardano/scripts/*
RUN chmod 540 /cardano/bin/*

ENV PATH=/cardano/scripts:/cardano/bin:$PATH
ENV CARDANO_NODE_SOCKET_PATH=/cardano/socket/node.sock

# Image clean-up
WORKDIR /root

RUN cabal clean
RUN rm -rf cardano-node
RUN rm -rf .cabal .local
RUN apt-get purge -y apt-utils
RUN apt-get purge -y git
RUN apt-get purge -y wget
RUN apt-get purge -y pkg-config
RUN apt-get purge -y libgmp-dev
RUN apt-get purge -y libssl-dev
RUN apt-get purge -y libtinfo-dev
RUN apt-get purge -y libsystemd-dev
RUN apt-get purge -y zlib1g-dev
RUN apt-get purge -y llvm
RUN apt-get purge -y build-essential
RUN apt-get purge -y libffi-dev
RUN apt-get purge -y make
RUN apt-get purge -y g++

RUN apt-get autoremove -y
RUN apt-get clean
RUN apt-get autoclean

# Switch user
USER cardano:cardano
WORKDIR /cardano

CMD ["/bin/bash", "-c", "start-relay.sh"]
