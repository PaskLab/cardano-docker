FROM ubuntu:jammy
LABEL name="squid"
LABEL description="SQUID - Caching and forwarding HTTP web proxy"
LABEL maintainer="https://github.com/pascallapointe"

WORKDIR /root

# Install base utilities and dependencies
RUN apt-get update
RUN apt-get install -y squid

# Create files structure
RUN mkdir /scripts /config

# Add startup scripts
COPY files/start.sh /scripts/start.sh

# Add permissions
RUN chmod g+s /scripts
RUN chmod 540 /scripts/*

ENV PATH=/scripts:$PATH

RUN apt-get autoremove -y
RUN apt-get clean
RUN apt-get autoclean

CMD ["/bin/bash", "-c", "tail","-f","/dev/null"]
