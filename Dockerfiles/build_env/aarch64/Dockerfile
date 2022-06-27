FROM ubuntu:focal
LABEL name="cardano_env"
LABEL description="AARCH64 Environment for building Cardano node & tools"
LABEL maintainer="https://github.com/pascallapointe"

# Define environment variables
ENV PATH=/root/.cabal/bin:/root/.ghcup/bin:$PATH
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
RUN apt-get install -y llvm-9
RUN apt-get install -y automake
RUN apt-get install -y make
RUN apt-get install -y build-essential
RUN apt-get install -y libffi-dev
RUN apt-get install -y libncursesw5
RUN apt-get install -y g++
RUN apt-get install -y tmux
RUN apt-get install -y jq
RUN apt-get install -y libnuma-dev
RUN apt-get install -y libtool
RUN apt-get install -y autoconf

# Install aarch64 ghcup-0.1.13
RUN wget -O ghcup https://downloads.haskell.org/~ghcup/0.1.14/aarch64-linux-ghcup-0.1.14
RUN chmod 500 ghcup
RUN ./ghcup -v --downloader wget install ghc 8.10.4
RUN ./ghcup set ghc 8.10.4

# Install aarch64 cabal 3.4
RUN ./ghcup -v --downloader wget install cabal

# Install Bitcoin secp256k1 dependency
RUN git clone https://github.com/bitcoin-core/secp256k1.git

WORKDIR /root/secp256k1

RUN git reset --hard ac83be33d0956faf6b7f61a60ab524ef7d6a473a

RUN ./autogen.sh

RUN ./configure --enable-module-schnorrsig --enable-experimental

RUN make

RUN make install

WORKDIR /root

# Install Cardano Libsodium dependencies
RUN git clone https://github.com/input-output-hk/libsodium

WORKDIR /root/libsodium
RUN git checkout 66f017f1
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install

ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

WORKDIR /root

# Image clean-up
RUN rm -rf secp256k1
RUN rm -rf libsodium
RUN cabal clean
RUN apt-get autoremove -y
RUN apt-get clean
RUN apt-get autoclean