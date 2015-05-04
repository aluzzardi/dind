#!/usr/bin/env bash
set -e

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

. utils.sh

if [ -z "$MAGIC" ] ; then
	echo "Are you sure you know what you're doing?"
	exit 1
fi

for tag in `git tag -l`; do
	run git tag -d "${tag}"
	run git push origin ":refs/tags/${tag}"
done
