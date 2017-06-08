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
    # Anything > 17.06.0-ce-rc1 needs the arch suffix in the archive name
    local year=$(echo $1 | cut -d. -f1)
    local month=$(echo $1 | cut -d. -f2)
    if (( $month > 6  && $year >= 17 )); then
        echo "-x86_64"
    elif (( $month == 6  && $year == 17 )); then
        local patch=$(echo $1 | cut -d. -f3 | cut -d- -f1)
        local rc=$(echo $1 | cut -d- -f3)
        [[ $rc == "rc1" && $patch == "0" ]] || echo "-x86_64"
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
