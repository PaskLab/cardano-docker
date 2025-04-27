FROM ubuntu:bionic
LABEL name="grafana"
LABEL description="Grafana server"
LABEL maintainer="https://github.com/pascallapointe"

WORKDIR /cardano

# Install base utilities and dependencies
RUN apt-get update
RUN apt-get install -y wget
# Grafana dependencies
RUN apt-get install -y adduser
RUN apt-get install -y libfontconfig1

# Define arguments/variables
ARG GRAF_DIR="grafana"
ARG GRAF_FILE="grafana-enterprise-11.6.0.linux-arm64.tar.gz"
ARG GRAF_URL="https://dl.grafana.com/enterprise/release/${GRAF_FILE}"

# Download all libraries
RUN wget ${GRAF_URL}

# Extract files
RUN mkdir ${GRAF_DIR}
RUN tar zxC ${GRAF_DIR} -f ${GRAF_FILE} --strip-components 1

# Add Grafana configuration, can be overridden using a 'bind mount' volume
COPY files/grafana.ini /cardano/config/grafana.ini

# Creating non root user cardano
RUN useradd -m cardano

# Add permissions
RUN chown -R cardano:cardano /cardano
RUN chmod g+s /cardano
RUN chmod 540 /cardano/${GRAF_DIR}/bin/*

# Export executable path
ENV PATH=/cardano/${GRAF_DIR}/bin:$PATH

# Image clean-up
RUN rm ${GRAF_FILE}

RUN apt-get purge -y wget

RUN apt-get autoremove -y
RUN apt-get clean
RUN apt-get autoclean

USER cardano:cardano

CMD ["grafana-server", "--config", "/cardano/config/grafana.ini", "--homepath", "/cardano/grafana"]
