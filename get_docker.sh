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

function arch_suffix() {
    # 17.06.0-ce-rc2 and rc3 need the arch suffix in the archive name
    if [[ $1 == '17.06.0-ce-rc2' || $1 == '17.06.0-ce-rc3' ]]; then
        echo "-x86_64"
    fi
}

if [[ "$VERSION" == *"rc"* ]]; then
    STAGE=test
elif is_stable $VERSION; then
    STAGE=stable
else
    STAGE=edge
fi

curl -L -f  \
    https://download.docker.com/linux/static/${STAGE}/x86_64/docker-${VERSION}$(arch_suffix $VERSION).tgz \
    | tar -xz
mv docker/* /usr/bin
rmdir docker
