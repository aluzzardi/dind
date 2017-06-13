#!/bin/bash
#
# Check for new docker versions. Build and push an image for any
# version that doesn't already exist.
#

set -e

DOCKER_REPOSITORY=https://github.com/docker/docker-ce.git

MIN_DOCKER_VERSION_TAG=${MIN_DOCKER_VERSION_TAG-"v1.12.0"}

DOCKER_IMAGE=${DOCKER_IMAGE:-dockerswarm/dind}

# Sort versions correctly with rc releases. This will break if there
# are more than 9 bug fix releases in a minor version
function tags_after() {
    local min_version=$1
    sort -t"." -k "1,3.1Vr" -k "3.2,3.2" | \
    sed "/^${min_version}\$/q" | \
    sort -t"." -k "1,3.1V"  -k "3.2,3.2r"
}

# Docker version tags starting from MIN_VERSION
tags=$(
    git ls-remote --tags $DOCKER_REPOSITORY v\* |
    awk -F'/' '{ print $3 }' |
    grep -v "\^{}" |
    tags_after $MIN_DOCKER_VERSION_TAG |
    sed "s/^v//"
)

tags=$(python tags_compare.py "$tags")

for version in $tags
do
    echo "Building version $version"
    image="${DOCKER_IMAGE}:${version}"
    ./build.sh $version
    ./test.sh $image
    docker push $image
done


