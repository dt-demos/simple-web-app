#!/bin/bash

baseimage=$1
tag=$2

# number of images
if [ $# -lt 3 ]
then
  numberimages=1
else
  numberimages=$3
fi

if [ -z $baseimage ]; then
  echo "ABORTING: Image is a required argument"
  echo "example usage: ./build.sh dtdemos/simple-web-service 0.1.0"
  exit 1
fi

if [ -z $tag ]; then
  echo "ABORTING: Tag is a required argument"
  echo "example usage: ./build.sh dtdemos/simple-web-service 0.1.0"
  exit 1
fi

for imageid in $(eval echo "{1..$numberimages}")
do
  echo "==============================================="
  echo "build $baseimage-$imageid:$tag"
  echo "==============================================="
  docker build --rm -t $baseimage-$imageid:$tag --build-arg SERVICE_NAME=simple-web-service-$imageid .
done

echo ""
echo "==============================================="
echo "local images"
echo "==============================================="
docker images | grep simple-web-service