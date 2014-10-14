#!/bin/bash

tag_name="$1"

if [ "$tag_name" == "" ]; then
  echo "Missing argument: tag name"
  exit 1
fi

set -e
set -x

docker build --rm --no-cache -t=evgenyg/ansible .
docker push evgenyg/ansible

id="$(docker images evgenyg/ansible | grep latest | awk '{print $3}')"
docker tag "$id" "evgenyg/ansible:$tag_name"
docker push      "evgenyg/ansible:$tag_name"
