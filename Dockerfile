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

ENV VERSION 1.2.0
RUN curl -L -o /usr/local/bin/docker https://get.docker.com/builds/Linux/x86_64/docker-${VERSION} \
    && chmod +x /usr/local/bin/docker

RUN curl -L -o /dind https://raw.githubusercontent.com/docker/docker/master/hack/dind \
    && chmod +x /dind

VOLUME /var/lib/docker

ENTRYPOINT ["/dind"]
