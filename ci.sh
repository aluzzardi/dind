#!/bin/bash
#
# Check for new docker versions. Build and push an image for the latest
# version if it doesn't already exist.
#

set -e

DOCKER_REPOSITORY=https://github.com/docker/docker.git

MIN_DOCKER_VERSION_TAG=${MIN_DOCKER_VERSION_TAG-"v1.8.2"}

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
latest=$(
    git ls-remote --tags $DOCKER_REPOSITORY v\* |
    awk -F'/' '{ print $3 }' |
    grep -v "\^{}" |
    tags_after $MIN_DOCKER_VERSION_TAG |
    tail -1 |
    sed "s/^v//"
)

image="${DOCKER_IMAGE}:${latest}"

if docker pull $image; then
    echo "Version $latest already exists."
    exit
fi

echo "Building version $latest"
./build.sh $latest
docker push $image
