FROM ubuntu:bionic
LABEL name="cardano_exporter"
LABEL description="Monitoring tools for Cardano node host machine"
LABEL maintainer="https://github.com/pascallapointe"

WORKDIR /root

# Install base utilities and dependencies
RUN apt-get update
RUN apt-get install -y wget

# Define arguments/variables
ARG NEXP_DIR="node_exporter"
ARG NEXP_FILE="node_exporter-1.0.1.linux-arm64.tar.gz"
ARG NEXP_URL="https://github.com/prometheus/node_exporter/releases/download/v1.0.1/$NEXP_FILE"
# Download all libraries
RUN wget ${NEXP_URL}

# Extract files
RUN mkdir ${NEXP_DIR}
RUN tar zxC ${NEXP_DIR} -f ${NEXP_FILE} --strip-components 1

# Export executable path
ENV PATH=/root/${NEXP_DIR}:$PATH

# Image clean-up
RUN rm ${NEXP_FILE}
RUN apt-get purge -y wget

RUN apt-get autoremove -y
RUN apt-get clean
RUN apt-get autoclean

CMD ["node_exporter"]