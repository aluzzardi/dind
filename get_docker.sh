#!/bin/bash
set -e

if [[ "$VERSION" == *"rc"* ]]; then
    HOST=test.docker.com
else
    HOST=get.docker.com
fi

curl -L -f -o /usr/local/bin/docker \
    https://$HOST/builds/Linux/x86_64/docker-${VERSION}

chmod +x /usr/local/bin/docker
