#!/usr/bin/env bash
set -e

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

. utils.sh

DOCKER_REPOSITORY=https://github.com/docker/docker.git

MIN_DOCKER_VERSION_TAG=${MIN_DOCKER_VERSION_TAG-"v1.8.2"}

# Docker version tags starting from MIN_VERSION
DOCKER_VERSION_TAGS=$(
    git ls-remote --tags $DOCKER_REPOSITORY v\* |
    awk -F'/' '{ print $3 }' |
    grep -v "\^{}" |
    tags_after $MIN_DOCKER_VERSION_TAG
)

function tag_exists() {
	git rev-parse $1 >/dev/null 2>&1
}

function update_to() {
	local version=$(echo $1 | sed "s/^v//")
	run sed -i "s/^ENV VERSION.*/ENV VERSION $version/" Dockerfile
	run git commit -m "Updated to $version" Dockerfile
}

for tag in $DOCKER_VERSION_TAGS; do
	if ! tag_exists $tag; then
		update_to $tag
		run git tag $tag
	fi
done

run git push --tags
