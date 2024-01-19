FROM ubuntu:jammy
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
RUN apt-get install -y liblmdb-dev
RUN apt-get install -y libsodium-dev
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y llvm-14
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

# Install aarch64 ghcup-0.1.18.0
RUN wget -O ghcup https://downloads.haskell.org/~ghcup/0.1.20.0/aarch64-linux-ghcup-0.1.20.0
RUN chmod 500 ghcup

RUN ./ghcup -v --downloader wget install ghc 9.6.4
RUN ./ghcup set ghc 9.6.4

# Install aarch64 cabal 3.10.1.0
RUN ./ghcup -v --downloader wget install cabal 3.10.1.0

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
RUN git checkout dbb48cc
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install

ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

WORKDIR /root

# Install BLST dependencies
RUN git clone https://github.com/supranational/blst
WORKDIR /root/blst
RUN git checkout v0.3.10
RUN ./build.sh
COPY files/libblst.pc /usr/local/lib/pkgconfig/libblst.pc
RUN cp bindings/blst_aux.h bindings/blst.h bindings/blst.hpp /usr/local/include/
RUN cp libblst.a /usr/local/lib
RUN chmod u=rw,go=r /usr/local/lib/pkgconfig/libblst.pc /usr/local/include/blst_aux.h /usr/local/include/blst.h /usr/local/include/blst.hpp /usr/local/lib/libblst.a

WORKDIR /root

# Image clean-up
RUN rm -rf secp256k1
RUN rm -rf libsodium
RUN rm -rf blst
RUN cabal clean
RUN apt-get autoremove -y
RUN apt-get clean
RUN apt-get autoclean
