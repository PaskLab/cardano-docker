FROM cardano_env AS base

LABEL name="cardano_submit"
LABEL description="Cardano Submit API"
LABEL maintainer="https://github.com/pascallapointe"

WORKDIR /root

# Download cardano-node repository
ARG ARCHITECTURE
ARG NODE_TAG
RUN git clone https://github.com/input-output-hk/cardano-node
WORKDIR /root/cardano-node
RUN git checkout ${NODE_TAG}
RUN git submodule update --init --recursive

# Add cabal config files
COPY files/cabal.project.local /root/cardano-node/cabal.project.local

# Build cardano-node binary
RUN cabal update
RUN cabal user-config update
RUN cabal build exe:cardano-submit-api --disable-tests

# Create files structure
RUN mkdir -p /cardano/config /cardano/bin /cardano/db /cardano/socket /cardano/scripts
ARG GHC_VERSION=ghc-9.6.4
ARG API_VERSION
RUN cp -p dist-newstyle/build/${ARCHITECTURE}-linux/${GHC_VERSION}/cardano-submit-api-${API_VERSION}/x/cardano-submit-api/build/cardano-submit-api/cardano-submit-api /cardano/bin

# Add startup scripts
COPY files/start.sh /cardano/scripts/start.sh

# Creating non root user cardano
#RUN useradd -m cardano

# Add permissions
#RUN chown -R cardano:cardano /cardano
RUN chmod g+s /cardano
RUN chmod 540 /cardano/scripts/*
RUN chmod 540 /cardano/bin/*

ENV PATH=/cardano/scripts:/cardano/bin:$PATH

# Image clean-up
WORKDIR /root

RUN cabal clean &&\
    rm -rf cardano-node &&\
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
#USER cardano:cardano
WORKDIR /cardano

FROM ubuntu:jammy
COPY --from=base / /

ENV PATH=/cardano/scripts:/cardano/bin:$PATH
ENV CARDANO_NODE_SOCKET_PATH=/cardano/socket/node.sock
ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

CMD ["/bin/bash", "-c", "start.sh"]
