#!/usr/bin/env bash

# Build tags passed in the command line or all tags.
TAGS=${@:-`git tag | sort`}

DOCKER_IMAGE=${DOCKER_IMAGE:-dockerswarm/dind}
CURRENT_BRANCH=$(git symbolic-ref HEAD | sed s:refs/heads/::)

# Go back to the current branch when the script finishes.
trap "git checkout $CURRENT_BRANCH" EXIT

function tag_to_image() {
	local version=$(echo $tag | sed "s/^v//")
	echo ${DOCKER_IMAGE}:$version
}

echo "Building images..."
for tag in $TAGS; do
	echo "Building $tag"
	git checkout $tag
	docker build -t `tag_to_image $tag` .
done

echo "Pushing images..."
for tag in $TAGS; do
	echo "Pushing $tag"
	docker push `tag_to_image $tag`
done
