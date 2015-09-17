#!/usr/bin/env bash
set -e

CURRENT_BRANCH=$(git symbolic-ref HEAD | sed s:refs/heads/::)

# Go back to the current branch when the script finishes.
trap "run git checkout $CURRENT_BRANCH" EXIT

function run() {
	echo "++ $@"
	"$@"
}

# Sort versions correctly with rc releases. This will break if there
# are more than 9 bug fix releases in a minor version
function tags_after() {
    local min_version=$1
    sort -t"." -k "1,3.1Vr" -k "3.2,3.2" | \
    sed "/^${min_version}\$/q" | \
    sort -t"." -k "1,3.1V"  -k "3.2,3.2r"
}
