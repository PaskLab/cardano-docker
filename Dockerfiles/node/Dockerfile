FROM cardano_sources

LABEL name="cardano_node"
LABEL description="Cardano node"
LABEL maintainer="https://github.com/pascallapointe"

WORKDIR /root/cardano-node

# Keep repository scripts folder
RUN cp -r scripts ../.

# Add start-relay.sh to the other scripts
COPY scripts/start-relay.sh /root/scripts/start-relay.sh

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