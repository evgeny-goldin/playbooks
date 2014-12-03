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

time docker push "$owner/$image"
time docker push "$owner/$image:$tag"

echo '---------------------------------------'
echo "Remeber to update the image description"
echo '---------------------------------------'
open "https://registry.hub.docker.com/u/$owner/$image/"

set +e
set +x
