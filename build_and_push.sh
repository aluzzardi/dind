#!/usr/bin/env bash
set -e

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

. utils.sh

# Build tags passed in the command line or all tags starting at min version
MIN_VERSION_TAG=${MIN_VERSION_TAG-"v1.8.2"}
TAGS=${@:-$(git tag | tags_after $MIN_VERSION_TAG)}

DOCKER_IMAGE=${DOCKER_IMAGE:-dockerswarm/dind}

function tag_to_image() {
	local version=$(echo $tag | sed "s/^v//")
	echo ${DOCKER_IMAGE}:$version
}

function run() {
	echo "++ $@"
	$@
}

echo "Building images..."
for tag in $TAGS; do
	echo
	run git checkout $tag
	run docker build -t `tag_to_image $tag` .
done

echo "Pushing images..."
for tag in $TAGS; do
	echo
	run docker push `tag_to_image $tag`
done
