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
  echo "example usage: ./push.sh dtdemos/simple-web-app 0.1.0"
  exit 1
fi

if [ -z $tag ]; then
  echo "ABORTING: Tag is a required argument"
  echo "example usage: ./push.sh dtdemos/simple-web-app 0.1.0"
  exit 1
fi

for imageid in $(eval echo "{1..$numberimages}")
do
  echo "==============================================="
  echo "push $baseimage-$imageid:$tag"
  echo "==============================================="
  docker push $baseimage-$imageid:$tag
done
