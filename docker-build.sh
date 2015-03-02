#!/bin/bash

owner='evgenyg'
image="$1"
tag="$2"
dockerfile="docker/$image/Dockerfile"

if [ "$image" == "" ] || [ "$tag" == "" ]; then
  echo "Arguments: <image> <tag>"
  exit 1
fi

echo '-------------------------------------------------------------------------'
echo "Building '$owner/$image:$tag' from '$dockerfile'"
echo '-------------------------------------------------------------------------'

set -e
set -x

cp "$dockerfile" .
# http://stackoverflow.com/a/12451419/472153
exec 5>&1
output=$(docker build --rm --no-cache -t="$owner/$image" . | tee >(cat - >&5))
image_id=$(echo "$output" | tail -1 | awk '{print $3}')
docker tag -f "$image_id" "$owner/$image:$tag"

set +e
set +x

echo '-------------------------------------------------------------------------'
echo "Image '$image_id' is built from '$dockerfile' and tagged as '$owner/$image:$tag' "
echo '-------------------------------------------------------------------------'

rm  Dockerfile
