FROM cardano_env AS base

LABEL name="db_sync"
LABEL description="Cardano DB Sync"
LABEL maintainer="https://github.com/pascallapointe"

WORKDIR /root

# Install base utilities and dependencies
RUN apt-get update && \
    apt-get install -y libghc-postgresql-libpq-dev libpq5 postgresql postgresql-contrib

# Download cardano-node repository
ARG RELEASE
ARG ARCHITECTURE
ARG PGPASSFILE="config/pgpass-mainnet scripts/postgresql-setup.sh --createdb"
RUN git clone https://github.com/input-output-hk/cardano-db-sync
WORKDIR /root/cardano-db-sync
RUN git checkout ${RELEASE}

# Build cardano-node binary
RUN cabal update && cabal build cardano-db-sync cardano-db-tool

# Create files structure
RUN mkdir -p /cardano/config /cardano/bin /cardano/ledger-state
ARG RELEASE_PATH=$RELEASE
ARG GHC_VERSION=ghc-9.6.4
RUN cp -p dist-newstyle/build/${ARCHITECTURE}-linux/${GHC_VERSION}/cardano-db-sync-${RELEASE_PATH}/build/cardano-db-sync/cardano-db-sync /cardano/bin && \
    cp -p dist-newstyle/build/${ARCHITECTURE}-linux/${GHC_VERSION}/cardano-db-tool-${RELEASE_PATH}/x/cardano-db-tool/build/cardano-db-tool/cardano-db-tool /cardano/bin

WORKDIR /root
RUN mv cardano-db-sync/schema /cardano/.

# Add startup scripts
COPY files/start.sh /cardano/scripts/start.sh
COPY files/sleep.sh /cardano/scripts/sleep.sh

# Add permissions
RUN chmod g+s /cardano && \
    chmod 540 /cardano/scripts/* && \
    chmod 540 /cardano/bin/*

# Image clean-up
WORKDIR /root

#RUN cabal clean
RUN rm -rf cardano-db-sync && \
    rm -rf .cabal .local && \
    apt-get purge -y apt-utils && \
    apt-get purge -y git && \
    apt-get purge -y wget && \
    apt-get purge -y pkg-config && \
    apt-get purge -y libgmp-dev && \
    apt-get purge -y libssl-dev && \
    apt-get purge -y libtinfo-dev && \
    apt-get purge -y libsystemd-dev && \
    apt-get purge -y zlib1g-dev && \
    apt-get purge -y llvm && \
    apt-get purge -y build-essential && \
    apt-get purge -y libffi-dev && \
    apt-get purge -y make && \
    apt-get purge -y g++

RUN apt-get autoremove -y && \
    apt-get clean && \
    apt-get autoclean

FROM ubuntu:jammy
COPY --from=base / /

ENV PATH=/cardano/scripts:/cardano/bin:$PATH
ENV CARDANO_NODE_SOCKET_PATH=/cardano/socket/node.sock
ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

# Switch user
# USER cardano:cardano
WORKDIR /cardano

CMD ["/bin/bash", "-c", "start.sh"]

