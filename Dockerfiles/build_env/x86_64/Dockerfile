FROM ubuntu:focal
LABEL name="cardano_env"
LABEL description="X86/AMD64 Environment for building Cardano node & tools"
LABEL maintainer="https://github.com/pascallapointe"

ENV PATH=/root/.local/bin:/root/.cabal/bin:/root/scripts:$PATH
ENV CARDANO_NODE_SOCKET_PATH=/root/node_data/socket
ENV DEBIAN_FRONTEND=noninteractive

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
RUN apt-get install -y automake
RUN apt-get install -y make
RUN apt-get install -y build-essential
RUN apt-get install -y libffi-dev
RUN apt-get install -y libncursesw5
RUN apt-get install -y g++
RUN apt-get install -y tmux
RUN apt-get install -y jq

# Install Haskell plateform
# Install version 3.0 of Cabal-Install
RUN wget https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz
RUN tar -xf cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz
RUN rm cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz cabal.sig
RUN mkdir -p .local/bin
RUN mv cabal .local/bin/

# Install version 8.6 of haskell compiler GHC
RUN wget https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-x86_64-deb9-linux.tar.xz
RUN tar -xf ghc-8.6.5-x86_64-deb9-linux.tar.xz
WORKDIR /root/ghc-8.6.5
RUN ./configure
RUN make install
WORKDIR /root
RUN rm -rf ghc-8.6.5 ghc-8.6.5-x86_64-deb9-linux.tar.xz

# Make the ghc symlink point to the newer version 8.6
RUN ln -sf /usr/local/bin/ghc /usr/bin/ghc

# Install Cardano Libsodium dependencies
RUN apt-get install -y libtool
RUN apt-get install -y autoconf

RUN git clone https://github.com/input-output-hk/libsodium

WORKDIR /root/libsodium
RUN git checkout 66f017f1
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install

ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"

WORKDIR /root
RUN rm -rf libsodium

# Image clean-up
RUN apt-get autoremove -y
RUN apt-get clean
RUN apt-get autoclean