#!/usr/bin/env bash

[ "${TRAVIS_PULL_REQUEST}" != 'false' ] && exit
[ "${TRAVIS_BRANCH}" != 'develop' ] && exit

GIT_COMMITTER_EMAIL='travis@digitalr00ts.com'
GIT_COMMITTER_NAME='Travis CI'
GIT_REPO_PUSH="git@$(git remote -v | head -n1 | grep -o --color=never 'github\.com.* ' | sed 's/\//\:/')"
GIT_BASE='master'

git fetch origin ${GIT_BASE}:${GIT_BASE}
git checkout ${GIT_BASE}
git merge --ff-only "$TRAVIS_COMMIT"
git push ${GIT_REPO_PUSH}
