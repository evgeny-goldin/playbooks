#!/bin/bash

root=../..
tag_name="$1"

if [ "$tag_name" == "" ]; then
  echo "Missing argument: tag name"
  exit 1
fi

set -e
set -x

cp Dockerfile                                "$root"
docker build --rm --no-cache -t=evgenyg/ruby "$root"
rm                                           "$root/Dockerfile"
docker push evgenyg/ruby

id="$(docker images evgenyg/ruby | grep latest | awk '{print $3}')"
docker tag "$id" "evgenyg/ruby:$tag_name"
docker push      "evgenyg/ruby:$tag_name"
