#!/bin/bash

owner='evgenyg'
image="$1"
tag="$2"
dockerfile="docker/$image/Dockerfile"

if [ "$image" == "" ] || [ "$tag" == "" ]; then
  echo "Arguments: <image> <tag>"
  exit 1
fi

if [ "$(docker images | grep "$owner/$image" | awk '{print $2}' | grep "$tag" | wc -l | awk '{print $1}')" == "1" ]; then
  echo '-------------------------------------------------------------------------'
  echo "Found '$owner/$image:$tag'"
  echo '-------------------------------------------------------------------------'
else
  ./docker-build.sh "$image" "$tag"
fi

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
