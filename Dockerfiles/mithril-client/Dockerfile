FROM cardano_env

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

RUN cabal clean
RUN rm -rf mithril
RUN rm -rf .cabal .local
RUN apt-get purge -y apt-utils
RUN apt-get purge -y git
RUN apt-get purge -y wget
RUN apt-get purge -y pkg-config
RUN apt-get purge -y libgmp-dev
RUN apt-get purge -y libssl-dev
RUN apt-get purge -y libtinfo-dev
RUN apt-get purge -y libsystemd-dev
RUN apt-get purge -y liblmdb-dev
RUN apt-get purge -y zlib1g-dev
RUN apt-get purge -y llvm-14
RUN apt-get purge -y build-essential
RUN apt-get purge -y libffi-dev
RUN apt-get purge -y make
RUN apt-get purge -y g++

RUN apt-get autoremove -y
RUN apt-get clean
RUN apt-get autoclean

# Switch user
# USER cardano:cardano
WORKDIR /cardano

CMD ["/bin/bash", "-c", "tail","-f","/dev/null"]
