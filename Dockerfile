# +-----------------------------------+
# | Official Pterodactyl Docker Image |
# |         Minecraft: BungeeCord     |
# +-----------------------------------+
# |       https://pterodactyl.io      |
# +-----------------------------------+
FROM quay.io/pires/docker-jre:8u131

MAINTAINER parkervcp, <parker@parkervcp.com>

COPY ./entry.sh /entry.sh

RUN adduser -D -h /home/container container \
 && echo "http://dl-3.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
 && apk update \
 && apk upgrade --available \
 && apk add curl sqlite openssl-dev \
 && chmod +x /entry.sh

USER container

ENV HOME=/home/container USER=container

WORKDIR /home/container

CMD ["/bin/ash", "/entry.sh"] 
