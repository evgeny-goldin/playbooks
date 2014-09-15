#!/bin/bash

set -x

cp docker/ansible/Dockerfile .
docker build --rm --no-cache -t="evgenyg/ansible:1.7.1" .
