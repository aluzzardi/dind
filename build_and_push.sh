#!/usr/bin/env bash
set -e

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

# Build tags passed in the command line or all tags.
TAGS=${@:-`git tag | sort`}

DOCKER_IMAGE=${DOCKER_IMAGE:-dockerswarm/dind}
CURRENT_BRANCH=$(git symbolic-ref HEAD | sed s:refs/heads/::)

# Go back to the current branch when the script finishes.
trap "run git checkout $CURRENT_BRANCH" EXIT

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
