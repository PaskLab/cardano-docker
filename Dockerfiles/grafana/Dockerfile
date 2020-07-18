FROM ubuntu:bionic
LABEL name="grafana"
LABEL description="Grafana server"
LABEL maintainer="https://github.com/pascallapointe"

WORKDIR /root

# Install base utilities and dependencies
RUN apt-get update
RUN apt-get install -y wget
# Grafana dependencies
RUN apt-get install -y adduser
RUN apt-get install -y libfontconfig1

# Define arguments/variables
ARG GRAF_DIR="grafana"
ARG GRAF_FILE="grafana-7.0.6.linux-arm64.tar.gz"
ARG GRAF_URL="https://dl.grafana.com/oss/release/${GRAF_FILE}"

# Download all libraries
RUN wget ${GRAF_URL}

# Extract files
RUN mkdir ${GRAF_DIR}
RUN tar zxC ${GRAF_DIR} -f ${GRAF_FILE} --strip-components 1

# Add Grafana configuration, can be overridden using a 'bind mount' volume
COPY files/grafana.ini /root/config/grafana.ini

# Export executable path
ENV PATH=/root/${GRAF_DIR}/bin:$PATH

# Image clean-up
RUN rm ${GRAF_FILE}

RUN apt-get purge -y wget

RUN apt-get autoremove -y
RUN apt-get clean
RUN apt-get autoclean

CMD ["grafana-server", "--config /root/config/grafana.ini", "--homepath /root/grafana"]