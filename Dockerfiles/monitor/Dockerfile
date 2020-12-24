FROM ubuntu:focal
LABEL name="cardano_monitor"
LABEL description="Monitoring tools for Cardano node and its host"
LABEL maintainer="https://github.com/pascallapointe"

WORKDIR /cardano

# Install base utilities and dependencies
RUN apt-get update
RUN apt-get install -y wget

# Define arguments/variables
ARG PROM_DIR="prometheus"
ARG PROM_FILE="prometheus-2.19.2.linux-arm64.tar.gz"
ARG PROM_URL="https://github.com/prometheus/prometheus/releases/download/v2.19.2/${PROM_FILE}"

ARG NEXP_DIR="node_exporter"
ARG NEXP_FILE="node_exporter-1.0.1.linux-arm64.tar.gz"
ARG NEXP_URL="https://github.com/prometheus/node_exporter/releases/download/v1.0.1/${NEXP_FILE}"

# Download all libraries
RUN wget ${PROM_URL}
RUN wget ${NEXP_URL}

# Extract files
RUN mkdir ${PROM_DIR}
RUN tar zxC ${PROM_DIR} -f ${PROM_FILE} --strip-components 1

RUN mkdir ${NEXP_DIR}
RUN tar zxC ${NEXP_DIR} -f ${NEXP_FILE} --strip-components 1

# Install start script
COPY files/start-monitoring.sh /cardano/scripts/start-monitoring.sh
RUN chmod 544 /cardano/scripts/start-monitoring.sh

# Add Prometheus configuration, can be overridden using a 'bind mount' volume
COPY files/prometheus.yml /cardano/config/prometheus.yml

# Creating non root user cardano
RUN useradd -m cardano

# Add data store folder
RUN mkdir /cardano/data

# Add permissions
RUN chown -R cardano:cardano /cardano
RUN chmod g+s /cardano

# Export executable path
ENV PATH=/cardano/${PROM_DIR}:/cardano/${NEXP_DIR}:/cardano/scripts:$PATH

# Image clean-up
RUN rm ${PROM_FILE}
RUN rm ${NEXP_FILE}
RUN apt-get purge -y wget

RUN apt-get autoremove -y
RUN apt-get clean
RUN apt-get autoclean

USER cardano:cardano

CMD ["start-monitoring.sh"]