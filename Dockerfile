FROM resin/rpi-raspbian
MAINTAINER ben@benpiper.com

ENV BIND_USER=bind \
    BIND_VERSION=1:9.9.5 \
    DATA_DIR=/data

RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y bind9=${BIND_VERSION}* bind9-host=${BIND_VERSION}* dnsutils \
 && rm -rf /var/lib/apt/lists/*

COPY /example/srv/docker/bind/ /data
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 53/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/sbin/named"]
