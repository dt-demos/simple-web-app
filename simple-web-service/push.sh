#!/bin/bash

baseimage=$1
tag=$2

if [ -z $baseimage ]; then
  echo "ABORTING: Image is a required argument"
  echo "example usage: ./push.sh dtdemos/simple-web-service 0.1.0"
  exit 1
fi

if [ -z $tag ]; then
  echo "ABORTING: Tag is a required argument"
  echo "example usage: ./push.sh dtdemos/simple-web-service 0.1.0"
  exit 1
fi

for imageid in {1..3}
do
  echo "==============================================="
  echo "push $baseimage-$imageid:$tag"
  echo "==============================================="
  docker push $baseimage-$imageid:$tag
done
