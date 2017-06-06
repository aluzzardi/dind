#!/bin/bash
set -e

if [[ -z "$VERSION" ]]; then
    >&2 echo "A VERSION is required."
    exit 1
fi

function is_stable() {
    local month=$(echo $1 | cut -d. -f2)
    test $(expr $month % 3) -eq 0
}

if [[ "$VERSION" == *"rc"* ]]; then
    STAGE=test
elif is_stable $VERSION; then
    STAGE=stable
else
    STAGE=edge
fi

curl -L -f  \
    https://download.docker.com/linux/static/${STAGE}/x86_64/docker-${VERSION}.tgz \
    | tar -xz
mv docker/* /usr/bin
rmdir docker
