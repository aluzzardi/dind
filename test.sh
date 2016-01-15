#!/bin/bash
#
# Test the image starts correctly
#

set -e

if [[ -z "$1" ]]; then
    >&2 echo "Usage: $(basename $0) <image>"
    exit 1
fi

DOCKER_IMAGE=$1
BUILD_ID=dindtest-${BUILD_NUMBER-$USER}
TEST_HOST=tcp://0.0.0.0:2375


docker run -d --privileged \
    --name $BUILD_ID \
    $DOCKER_IMAGE \
    docker daemon -H $TEST_HOST $DOCKER_DAEMON_ARGS


function on_exit() {
    unset DOCKER_HOST
    if [[ "$?" != "0" ]]; then
        docker logs "$BUILD_ID" 2>&1 | tail -n 100
    fi
    docker rm -vf "$BUILD_ID"
}
trap "on_exit" exit

ip=$(docker inspect -f '{{.NetworkSettings.IPAddress}}' $BUILD_ID)
export DOCKER_HOST=tcp://$ip:2375

timeout 60 ./wait_on_daemon

docker ps
