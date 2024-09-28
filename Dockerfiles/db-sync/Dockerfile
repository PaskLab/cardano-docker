FROM cardano_env AS base

LABEL name="db_sync"
LABEL description="Cardano DB Sync"
LABEL maintainer="https://github.com/pascallapointe"

WORKDIR /root

# Install base utilities and dependencies
RUN apt-get update && \
    apt-get install -y libpq-dev postgresql-client

# Download Db-Sync repository
ARG RELEASE
ARG PGPASSFILE="config/pgpass-mainnet scripts/postgresql-setup.sh --createdb"
RUN git clone https://github.com/input-output-hk/cardano-db-sync
WORKDIR /root/cardano-db-sync
RUN git checkout ${RELEASE} && git submodule update --init --recursive

# Build db-sync binary
RUN cabal update && \
    cabal user-config update && \
    cabal build cardano-db-sync --disable-tests && \
    cabal build cardano-db-tool --disable-tests

# Create files structure
RUN mkdir -p /cardano/config /cardano/bin /cardano/ledger-state
ARG ARCHITECTURE
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
    apt-get purge -y apt-utils git wget pkg-config libgmp-dev \
        libssl-dev libtinfo-dev libsystemd-dev liblmdb-dev libtool \
        zlib1g-dev llvm-dev build-essential libffi-dev automake \
        make g++ libncursesw5 jq autoconf libpq-dev &&\
    apt-get autoremove -y && \
    apt-get clean && \
    apt-get autoclean

FROM ubuntu:jammy
COPY --from=base / /

ENV PATH=/cardano/scripts:/cardano/bin:$PATH
ENV CARDANO_NODE_SOCKET_PATH=/cardano/socket/node.sock
ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

WORKDIR /cardano

CMD ["/bin/bash", "-c", "start.sh"]

