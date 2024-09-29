FROM cardano_env AS base

LABEL name="mithril-signer"
LABEL description="Cardano Mithril Signer"
LABEL maintainer="https://github.com/pascallapointe"

WORKDIR /root

# Create files structure
RUN mkdir -p /cardano/config /cardano/bin /cardano/db /cardano/socket /cardano/scripts

# Download cardano-cli repository
ARG ARCHITECTURE
ARG CLI_TAG
RUN git clone https://github.com/IntersectMBO/cardano-cli.git
WORKDIR /root/cardano-cli
ARG GHC_VERSION=ghc-9.6.4
RUN git checkout cardano-cli-${CLI_TAG} && git submodule update --init --recursive

# Build cardano-cli binary
RUN cabal update && cabal user-config update && cabal build cardano-cli --disable-tests
RUN cp -p dist-newstyle/build/${ARCHITECTURE}-linux/${GHC_VERSION}/cardano-cli-${CLI_TAG}/x/cardano-cli/build/cardano-cli/cardano-cli /cardano/bin

# Download mithril repository
WORKDIR /root
ARG MITHRIL_TAG
RUN git clone https://github.com/input-output-hk/mithril.git
WORKDIR /root/mithril
RUN git checkout ${MITHRIL_TAG}
WORKDIR /root/mithril/mithril-signer

# Support for Asahi Linux 16kb memory page, to be commented if not needed
ENV JEMALLOC_SYS_WITH_LG_PAGE=16

# Build mithril binary
RUN make build
RUN cp -p mithril-signer /cardano/bin
RUN mkdir -p /cardano/stores

# Add startup scripts
COPY files/start.sh /cardano/scripts/start.sh

# Add permissions
RUN chmod g+s /cardano && chmod 540 /cardano/scripts/* && chmod 540 /cardano/bin/*

ENV PATH=/cardano/scripts:/cardano/bin:$PATH
ENV CARDANO_NODE_SOCKET_PATH=/cardano/socket/node.sock
ENV DB_DIRECTORY=/cardano/db
ENV CARDANO_CLI_PATH=/cardano/bin/cardano-cli
ENV DATA_STORES_DIRECTORY=/cardano/stores

# Image clean-up
WORKDIR /root

RUN cabal clean &&\
    rm -rf mithril &&\
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

FROM ubuntu:jammy
COPY --from=base / /

ENV PATH=/cardano/scripts:/cardano/bin:$PATH
ENV CARDANO_NODE_SOCKET_PATH=/cardano/socket/node.sock
ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

WORKDIR /cardano

CMD ["/bin/bash", "-c", "start.sh"]
