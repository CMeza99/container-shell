#!/usr/bin/env bash

# test -z "$1" && exit 1
# test -z "$2" && exit 1


[ "${TRAVIS_PULL_REQUEST}" != 'false' ] && exit
[ "${TRAVIS_BRANCH}" != 'develop' ] && exit

GIT_COMMITTER_EMAIL='travis@digitalr00ts.com'
GIT_COMMITTER_NAME='Travis CI'
GIT_REPO_PUSH="git@$(git remote -v | head -n1 | grep -o --color=never 'github\.com.* ' | sed 's/\//\:/')"
GIT_BASE='master'

# mkdir -p ~/.ssh/
# openssl aes-256-cbc -K $1 -iv $2 -in .travis/id_ed25519.enc -out ~/.ssh/id_ed25519 -d
# chmod 700 ~/.ssh/
# chmod 400 ~/.ssh/id_ed25519

git fetch origin ${GIT_BASE}:${GIT_BASE}
git checkout ${GIT_BASE}
git merge --ff-only "$TRAVIS_COMMIT"
git push ${GIT_REPO_PUSH}
