FROM ubuntu:jammy
LABEL name="cardano_env"
LABEL description="X86/AMD64 Environment for building Cardano node & tools"
LABEL maintainer="https://github.com/pascallapointe"

# Define environment variables
ENV PATH=/root/.cabal/bin:/root/.ghcup/bin:$PATH
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root

# Install base utilities and dependencies
RUN apt-get update && \
    apt-get install -y apt-utils git wget curl pkg-config \
    libgmp-dev libssl-dev libtinfo-dev libsystemd-dev liblmdb-dev \
    zlib1g-dev llvm-dev automake make build-essential \
    libffi-dev libncursesw5 g++ jq libnuma-dev libtool autoconf

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup update

# Install aarch64 ghcup-0.1.18.0
# Install aarch64 cabal 3.10.1.0
RUN wget -O ghcup https://downloads.haskell.org/~ghcup/0.1.20.0/x86_64-linux-ghcup-0.1.20.0 &&\
    chmod 500 ghcup &&\
    ./ghcup -v --downloader wget install ghc 9.10.2 &&\
    ./ghcup set ghc 9.10.2 &&\
    ./ghcup -v --downloader wget install cabal 3.12.1.0

# Install Bitcoin secp256k1 dependency
RUN git clone https://github.com/bitcoin-core/secp256k1.git

WORKDIR /root/secp256k1

RUN git checkout v0.3.2 &&\
    ./autogen.sh &&\
    ./configure --enable-module-schnorrsig --enable-experimental &&\
    make &&\
    make install

WORKDIR /root

# Install Cardano Libsodium dependencies
RUN git clone https://github.com/input-output-hk/libsodium

WORKDIR /root/libsodium
RUN git checkout dbb48cce5429cb6585c9034f002568964f1ce567 &&\
    ./autogen.sh &&\
    ./configure &&\
    make &&\
    make install

ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

WORKDIR /root

# Install BLST dependencies
RUN git clone https://github.com/supranational/blst
WORKDIR /root/blst
RUN git checkout v0.3.11 &&\
    ./build.sh
COPY files/libblst.pc /usr/local/lib/pkgconfig/libblst.pc
RUN cp bindings/blst_aux.h bindings/blst.h bindings/blst.hpp /usr/local/include/ &&\
    cp libblst.a /usr/local/lib &&\
    chmod u=rw,go=r /usr/local/lib/pkgconfig/libblst.pc /usr/local/include/blst_aux.h /usr/local/include/blst.h /usr/local/include/blst.hpp /usr/local/lib/libblst.a

WORKDIR /root

# Image clean-up
RUN rm -rf secp256k1 &&\
    rm -rf libsodium &&\
    rm -rf blst &&\
    cabal clean &&\
    apt-get autoremove -y &&\
    apt-get clean &&\
    apt-get autoclean
