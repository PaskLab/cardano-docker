FROM ubuntu:bionic
LABEL name="cardano_sources"
LABEL description="Sources for building Cardano node & tools"
LABEL maintainer="https://github.com/pascallapointe"

ENV PATH=/root/.cabal/bin:/root/scripts:$PATH
ENV CARDANO_NODE_SOCKET_PATH=/node_data/socket
WORKDIR /root

# Install base utilities and dependencies
RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y git
RUN apt-get install -y wget
RUN apt-get install -y pkg-config
RUN apt-get install -y libgmp-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y libtinfo-dev
RUN apt-get install -y libsystemd-dev
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y llvm
RUN apt-get install -y build-essential
RUN apt-get install -y libffi-dev
RUN apt-get install -y make
RUN apt-get install -y g++
RUN apt-get install -y tmux
RUN apt-get install -y jq

# Install Haskell plateform
RUN apt-get install -y haskell-platform

# Install version 8.6 of haskell compiler GHC
RUN wget https://downloads.haskell.org/ghc/8.6.5/ghc-8.6.5-aarch64-ubuntu18.04-linux.tar.xz
RUN tar -xf ghc-8.6.5-aarch64-ubuntu18.04-linux.tar.xz
WORKDIR /root/ghc-8.6.5
RUN ./configure
RUN make install
WORKDIR /root
RUN rm -rf ghc-8.6.5 ghc-8.6.5-aarch64-ubuntu18.04-linux.tar.xz

# Make the ghc symlink point to the newer version 8.6
RUN ln -sf /usr/local/bin/ghc /usr/bin/ghc

# Install version 3.0 of Cabal-Install
RUN wget http://hackage.haskell.org/package/cabal-install-3.0.0.0/cabal-install-3.0.0.0.tar.gz
RUN tar -xf cabal-install-3.0.0.0.tar.gz
WORKDIR /root/cabal-install-3.0.0.0
RUN cabal update
RUN cabal install
WORKDIR /root
RUN rm -rf cabal-install-3.0.0.0 cabal-install-3.0.0.0.tar.gz

# Download cardano-node repository
ARG RELEASE
RUN git clone https://github.com/input-output-hk/cardano-node
WORKDIR /root/cardano-node
RUN git checkout ${RELEASE}
RUN git submodule update --init --recursive

# Image clean-up
RUN apt-get autoremove -y
RUN apt-get clean
RUN apt-get autoclean