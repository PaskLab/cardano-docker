FROM cardano_env

LABEL name="cardano_cli"
LABEL description="Cardano CLI"
LABEL maintainer="https://github.com/pascallapointe"

WORKDIR /root

# Install Cardano Node dependencies
RUN apt-get install -y libsodium-dev

# Download cardano-node repository
ARG RELEASE
RUN git clone https://github.com/input-output-hk/cardano-node
WORKDIR /root/cardano-node
RUN git checkout ${RELEASE}
RUN git submodule update --init --recursive

# Keep scripts folder
RUN cp -r scripts ../.

# Build cardano-node binary
RUN cabal update
RUN cabal user-config update
RUN cabal install cardano-cli

# Image clean-up
WORKDIR /root

RUN rm -rf cardano-node
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

CMD ["/bin/bash"]