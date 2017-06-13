#!/bin/bash
set -e

if [[ -z "$1" ]]; then
    >&2 echo "Usage: $(basename $0) <version>"
    exit 1
fi

VERSION=$1
docker build --build-arg=VERSION=$VERSION -t dockerswarm/dind:$VERSION .
