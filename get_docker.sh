#!/bin/bash
set -e

if [[ -z "$VERSION" ]]; then
    >&2 echo "A VERSION is required."
    exit 1
fi

if [[ "$VERSION" == *"rc"* ]]; then
    HOST=test.docker.com
else
    HOST=get.docker.com
fi

curl -L -f -s -o /usr/local/bin/docker \
    https://$HOST/builds/Linux/x86_64/docker-${VERSION}

chmod +x /usr/local/bin/docker
