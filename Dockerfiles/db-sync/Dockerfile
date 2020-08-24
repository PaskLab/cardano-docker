FROM cardano_env

LABEL name="cardano_db_sync"
LABEL description="Cardano DB Sync"
LABEL maintainer="https://github.com/pascallapointe"

WORKDIR /root

RUN apt-get update
RUN apt-get install -y libpq-dev

# Download cardano-db-sync repository
ARG RELEASE
RUN git clone https://github.com/input-output-hk/cardano-db-sync.git
WORKDIR /root/cardano-db-sync
RUN git checkout ${RELEASE}
RUN git submodule update --init --recursive

# Build cardano-node binary
RUN cabal update
RUN cabal user-config update
RUN cabal build all

WORKDIR /root

# Image clean-up
#RUN rm -rf cardano-db-sync
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

CMD ["tail", "-f", "/dev/null"]
