FROM cardano_env

LABEL name="mithril-signer"
LABEL description="Cardano Mithril Signer"
LABEL maintainer="https://github.com/pascallapointe"

WORKDIR /root

# Download cardano-node repository
ARG NODE_TAG
ARG ARCHITECTURE
RUN git clone https://github.com/IntersectMBO/cardano-node.git
WORKDIR /root/cardano-node
RUN git checkout ${NODE_TAG}
RUN git submodule update --init --recursive

# Add cabal config files
COPY files/cabal.project.local /root/cardano-node/cabal.project.local

# Build cardano-node binary
RUN cabal update
RUN cabal user-config update
RUN cabal build cardano-cli

# Create files structure
RUN mkdir -p /cardano/config /cardano/bin /cardano/db /cardano/socket /cardano/scripts
ARG GHC_VERSION=ghc-9.6.4
ARG CLI_PATH
RUN cp -p dist-newstyle/build/${ARCHITECTURE}-linux/${GHC_VERSION}/cardano-cli-${CLI_PATH}/x/cardano-cli/build/cardano-cli/cardano-cli /cardano/bin

# Download mithril repository
WORKDIR /root
ARG MITHRIL_TAG
RUN git clone https://github.com/input-output-hk/mithril.git
WORKDIR /root/mithril
RUN git checkout ${MITHRIL_TAG}
WORKDIR /root/mithril/mithril-signer

# Build mithril binary
RUN make build
RUN cp -p mithril-signer /cardano/bin
RUN mkdir -p /cardano/stores

# Add startup scripts
COPY files/start.sh /cardano/scripts/start.sh

# Creating non root user cardano
# RUN useradd -m cardano

# Add permissions
# RUN chown -R cardano:cardano /cardano
RUN chmod g+s /cardano
RUN chmod 540 /cardano/scripts/*
RUN chmod 540 /cardano/bin/*

ENV PATH=/cardano/scripts:/cardano/bin:$PATH
ENV CARDANO_NODE_SOCKET_PATH=/cardano/socket/node.sock
ENV DB_DIRECTORY=/cardano/db
ENV CARDANO_CLI_PATH=/cardano/bin/cardano-cli
ENV DATA_STORES_DIRECTORY=/cardano/stores

# Image clean-up
WORKDIR /root

RUN cabal clean
RUN rm -rf cardano-node
RUN rm -rf mithril
RUN rm -rf .cabal .local
RUN apt-get purge -y apt-utils
RUN apt-get purge -y git
RUN apt-get purge -y wget
RUN apt-get purge -y pkg-config
RUN apt-get purge -y libgmp-dev
RUN apt-get purge -y libssl-dev
RUN apt-get purge -y libtinfo-dev
RUN apt-get purge -y libsystemd-dev
RUN apt-get purge -y liblmdb-dev
RUN apt-get purge -y zlib1g-dev
RUN apt-get purge -y llvm-14
RUN apt-get purge -y build-essential
RUN apt-get purge -y libffi-dev
RUN apt-get purge -y make
RUN apt-get purge -y g++

RUN apt-get autoremove -y
RUN apt-get clean
RUN apt-get autoclean

# Switch user
# USER cardano:cardano
WORKDIR /cardano

CMD ["/bin/bash", "-c", "start.sh"]
