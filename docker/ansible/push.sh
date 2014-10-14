#!/bin/bash

set -e
set -x

docker build --rm --no-cache -t=evgenyg/ansible .
docker push evgenyg/ansible

id="$(docker images evgenyg/ansible | grep latest | awk '{print $3}')"
docker tag "$id" evgenyg/ansible:1.7.2
docker push      evgenyg/ansible:1.7.2
