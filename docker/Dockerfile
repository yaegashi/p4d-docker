FROM ubuntu:focal

RUN apt-get update && \
    apt-get install -y gnupg2 curl gosu pwgen && \
    echo "deb http://package.perforce.com/apt/ubuntu focal release" > /etc/apt/sources.list.d/perforce.list && \
    curl -sL https://package.perforce.com/perforce.pubkey | apt-key add - && \
    apt-get update && \
    apt-get install -y helix-p4d \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

VOLUME /opt/perforce/servers

EXPOSE 1666

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
