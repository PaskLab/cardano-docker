FROM cardano_env

LABEL name="cardano_node"
LABEL description="Cardano node"
LABEL maintainer="https://github.com/pascallapointe"

WORKDIR /root

# Install Cardano Node dependencies
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

# Download cardano-node repository
ARG RELEASE
RUN git clone https://github.com/input-output-hk/cardano-node
WORKDIR /root/cardano-node
RUN git checkout ${RELEASE}
RUN git submodule update --init --recursive

# Add files
COPY ../other/cabal.project.local /root/cardano-node/cabal.project.local
COPY ../scripts/start-relay.sh /root/scripts/start-relay.sh
COPY ../scripts/start-relay.sh /root/scripts/start-producer.sh

# Add execution right
RUN chmod +x /root/scripts/start-relay.sh

# Build cardano-node binary
RUN cabal update
RUN cabal user-config update
RUN cabal install cardano-node

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

CMD ["start-relay.sh"]