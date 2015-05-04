#!/usr/bin/env bash
set -e

CURRENT_BRANCH=$(git symbolic-ref HEAD | sed s:refs/heads/::)

# Go back to the current branch when the script finishes.
trap "run git checkout $CURRENT_BRANCH" EXIT

function run() {
	echo "++ $@"
	$@
}
