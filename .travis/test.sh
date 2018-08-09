#!/usr/bin/env bash

set -ex

#BUILD
docker-compose build --no-cache

#TEST
docker-compose run home cat /etc/redhat-release | grep -C 5 -iF Fedora
