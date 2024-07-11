FROM cardano_env

LABEL name="cardano_node"
LABEL description="Cardano node"
LABEL maintainer="https://github.com/pascallapointe"

WORKDIR /root

# Install base utilities and dependencies
RUN apt-get update
RUN apt-get install -y libghc-postgresql-libpq-dev
RUN apt-get install -y libpq5
RUN apt-get install -y postgresql postgresql-contrib

# Download cardano-node repository
ARG RELEASE
ARG ARCHITECTURE
ARG PGPASSFILE="config/pgpass-mainnet scripts/postgresql-setup.sh --createdb"
RUN git clone https://github.com/input-output-hk/cardano-db-sync
WORKDIR /root/cardano-db-sync
RUN git checkout ${RELEASE}

# Build cardano-node binary
RUN cabal update
RUN cabal build cardano-db-sync
RUN cabal build all

# Create files structure
RUN mkdir -p /cardano/config /cardano/bin /cardano/ledger-state
ARG RELEASE_PATH=$RELEASE
ARG GHC_VERSION=ghc-9.6.4
RUN cp -p dist-newstyle/build/${ARCHITECTURE}-linux/${GHC_VERSION}/cardano-db-sync-${RELEASE_PATH}/build/cardano-db-sync/cardano-db-sync /cardano/bin
RUN cp -p dist-newstyle/build/${ARCHITECTURE}-linux/${GHC_VERSION}/cardano-db-tool-${RELEASE_PATH}/x/cardano-db-tool/build/cardano-db-tool/cardano-db-tool /cardano/bin

WORKDIR /root
RUN mv cardano-db-sync/schema /cardano/.

# Add startup scripts
COPY files/start.sh /cardano/scripts/start.sh
COPY files/sleep.sh /cardano/scripts/sleep.sh

# Creating non root user cardano
RUN useradd -m cardano

# Add permissions
RUN chown -R cardano:cardano /cardano
RUN chmod g+s /cardano
RUN chmod 540 /cardano/scripts/*
RUN chmod 540 /cardano/bin/*

ENV PATH=/cardano/scripts:/cardano/bin:$PATH

# Image clean-up
WORKDIR /root

#RUN cabal clean
RUN rm -rf cardano-db-sync
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

CMD ["/bin/bash", "-c", "start.sh"]

