# JRE base
FROM openjdk:20-slim

# Environment variables
ENV MC_VERSION="latest" \
    WATERFALL_BUILD="latest" \
    MC_RAM="" \
    MC_PORT="" \
    JAVA_OPTS=""

COPY waterfall.sh .
RUN apt-get update \
    && apt-get install -y wget \
    && apt-get install -y jq \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /waterfall

# Start script
CMD ["sh", "./waterfall.sh"]

# Container setup
EXPOSE 25565/tcp
EXPOSE 25565/udp
VOLUME /waterfall
