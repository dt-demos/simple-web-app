#!/bin/bash

baseimage=$1
tag=$2

baseimage=dtdemos/boom-app
tag=0.1.0

docker build --rm -t $baseimage:$tag .
docker push $baseimage:$tag

exit