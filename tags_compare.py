import json
import sys
import urllib2

REPO_NAME = 'dockerswarm/dind'
URL = (
    'https://hub.docker.com/v2/repositories'
    '/{0}/tags/?page=1&page_size=250'.format(
        REPO_NAME
    )
)


def main(github_tags):
    github_tags = github_tags.split()
    res = urllib2.urlopen(URL)
    hub_tags = json.loads(res.read())
    hub_tags = [t['name'] for t in hub_tags['results']]
    for gh_t in github_tags:
        if gh_t not in hub_tags:
            print(gh_t)

main(sys.argv[1])
