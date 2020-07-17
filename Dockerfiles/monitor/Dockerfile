FROM ubuntu:bionic
LABEL name="cardano_monitor"
LABEL description="Grafana/Prometheus monitoring tools for Cardano node"
LABEL maintainer="https://github.com/pascallapointe"

WORKDIR /root

# Install base utilities and dependencies
RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y unzip
# Grafana dependencies
RUN apt-get install -y adduser
RUN apt-get install -y libfontconfig1

# Define arguments/variables
ARG PROM_DIR="prometheus"
ARG PROM_FILE="prometheus-2.19.2.linux-arm64.tar.gz"
ARG PROM_URL="https://github.com/prometheus/prometheus/releases/download/v2.19.2/${PROM_FILE}"

ARG GRAF_DIR="grafana"
ARG GRAF_FILE="grafana-7.0.6.linux-arm64.tar.gz"
ARG GRAF_URL="https://dl.grafana.com/oss/release/${GRAF_FILE}"

ARG CLOCK_FILE="grafana-clock-panel-1.1.1.zip"
ARG CLOCK_URL="https://github.com/grafana/clock-panel/releases/download/v1.1.1/${CLOCK_FILE}"

# Download all libraries
RUN wget ${PROM_URL}
RUN wget ${GRAF_URL}

# Extract files
RUN mkdir ${PROM_DIR}
RUN tar zxC ${PROM_DIR} -f ${PROM_FILE} --strip-components 1

RUN mkdir ${GRAF_DIR}
RUN tar zxC ${GRAF_DIR} -f ${GRAF_FILE} --strip-components 1

# Add Grafana plugin
#WORKDIR /root/grafana/plugins-bundled
#
#RUN wget ${CLOCK_URL}
#RUN unzip ${CLOCK_FILE}
#RUN rm ${CLOCK_FILE}
#
#WORKDIR /root

# Install start script
COPY files/start-monitoring.sh /root/scripts/start-monitoring.sh
RUN chmod +x /root/scripts/start-monitoring.sh

# Export executable path
ENV PATH=/root/${PROM_DIR}:/root/${GRAF_DIR}/bin:/root/scripts:$PATH

# Image clean-up
RUN rm ${PROM_FILE}
RUN rm ${GRAF_FILE}

RUN apt-get purge -y wget
RUN apt-get purge -y unzip

RUN apt-get autoremove -y
RUN apt-get clean
RUN apt-get autoclean

CMD ["start-monitoring.sh"]