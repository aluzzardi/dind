#!/usr/bin/env bash
set -e

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

. utils.sh

DOCKER_REPOSITORY=https://github.com/docker/docker.git

# Docker version tags starting from v1.0.0 excluding RCs
DOCKER_VERSION_TAGS=$(git ls-remote --tags $DOCKER_REPOSITORY \
	| cut -d$'\t' -f2 | cut -d'/' -f3 | grep -v "\^{}" \
	| grep "^v1\." | grep -v -- "-rc" | sort)

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
