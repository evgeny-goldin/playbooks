#!/bin/bash

owner='evgenyg'
image="$1"
tag="$2"
dockerfile="docker/$image/Dockerfile"

if [ "$image" == "" ] || [ "$tag" == "" ]; then
  echo "Arguments: <image> <tag>"
  exit 1
fi

./docker-build.sh "$image" "$tag"

echo '-------------------------------------------------------------------------'
echo "Pushing '$owner/$image:$tag'"
echo '-------------------------------------------------------------------------'

set -e
set -x

docker push "$owner/$image"
docker push "$owner/$image:$tag"

set +e
set +x
