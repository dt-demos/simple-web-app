#!/bin/bash

baseimage=$1
tag=$2

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

for imageid in {1..3}
do
  echo "==============================================="
  echo "build $baseimage-$imageid:$tag"
  echo "==============================================="
  docker build --rm -t $baseimage-$imageid:$tag --build-arg SERVICE_NAME=service-$imageid .
done

echo ""
echo "==============================================="
echo "local images"
echo "==============================================="
docker images | grep simple-web-service