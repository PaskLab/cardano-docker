FROM ubuntu:focal
LABEL name="cardano_env"
LABEL description="X86/AMD64 Environment for building Cardano node & tools"
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

# Install aarch64 ghcup-0.1.13
RUN wget -O ghcup https://downloads.haskell.org/~ghcup/0.1.14/x86_64-linux-ghcup-0.1.14
RUN chmod 500 ghcup
RUN ./ghcup -v --downloader wget install ghc 8.10.4
RUN ./ghcup set ghc 8.10.4

# Install aarch64 cabal 3.4
RUN ./ghcup -v --downloader wget install cabal

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
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

WORKDIR /root
RUN rm -rf libsodium

# Image clean-up
RUN cabal clean
RUN apt-get autoremove -y
RUN apt-get clean
RUN apt-get autoclean