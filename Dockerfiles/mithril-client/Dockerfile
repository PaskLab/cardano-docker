FROM cardano_env AS base

LABEL name="mithril-client"
LABEL description="Cardano Mithril Client"
LABEL maintainer="https://github.com/pascallapointe"

WORKDIR /root

# Create files structure
RUN mkdir -p /cardano/bin /cardano/db

# Download mithril repository
WORKDIR /root
ARG MITHRIL_TAG
RUN git clone https://github.com/input-output-hk/mithril.git
WORKDIR /root/mithril
RUN git checkout ${MITHRIL_TAG}
WORKDIR /root/mithril/mithril-client-cli

# Support for Asahi Linux 16kb memory page, to be commented if not needed
#ENV JEMALLOC_SYS_WITH_LG_PAGE=16

# Build mithril binary
RUN make build
RUN cp mithril-client /cardano/bin

# Creating non root user cardano
# RUN useradd -m cardano

# Add permissions
# RUN chown -R cardano:cardano /cardano
RUN chmod g+s /cardano
RUN chmod 540 /cardano/bin/*

ENV PATH=/cardano/scripts:/cardano/bin:$PATH

# Image clean-up
WORKDIR /root

RUN cabal clean &&\
    rm -rf mithril &&\
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

FROM ubuntu:jammy
COPY --from=base / /

ENV PATH=/cardano/scripts:/cardano/bin:$PATH
ENV CARDANO_NODE_SOCKET_PATH=/cardano/socket/node.sock
ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

# Switch user
# USER cardano:cardano
WORKDIR /cardano

CMD ["/bin/bash", "-c", "tail","-f","/dev/null"]
