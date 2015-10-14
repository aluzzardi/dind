# Dockerfile for building Docker
FROM debian:jessie

# compile and runtime deps
# https://github.com/docker/docker/blob/master/project/PACKAGERS.md#runtime-dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        iptables \
        procps \
        e2fsprogs \
        xz-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV VERSION 1.9.0-rc1
COPY get_docker.sh /get_docker.sh
RUN bash /get_docker.sh

RUN curl -L -o /dind https://raw.githubusercontent.com/docker/docker/master/hack/dind \
    && chmod +x /dind

VOLUME /var/lib/docker

ENTRYPOINT ["/dind"]
