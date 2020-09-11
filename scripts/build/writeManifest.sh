#!/bin/bash

IMAGE_NAME=$1
IMAGE_TAG=$2

if [ -z $IMAGE_NAME ]; then
  echo "ABORTING: IMAGE_NAME is a required argument"
  echo "example usage: ./writeManifest.sh dtdemos/simple-web-app 0.1.0"
  exit 1
fi

if [ -z $IMAGE_TAG ]; then
  echo "ABORTING: IMAGE_TAG is a required argument"
  echo "example usage: ./writeManifest.sh dtdemos/simple-web-app 0.1.0"
  exit 1
fi

DATE="$(date +'%Y%m%d.%H%M')"
REPO=$(git config --get remote.origin.url)
BRANCH=$(git rev-parse --abbrev-ref HEAD)
SHA=$(git rev-parse HEAD)

cat <<EOF > MANIFEST
{
    "buildDate" : "$DATE",
    "imageName" : "$IMAGE_NAME",
    "imageTag" : "$IMAGE_TAG",
    "gitHubRepo" : "$REPO",
    "gitHubBranch" : "$BRANCH",
    "gitHubSha" : "$SHA",
}
EOF

cat MANIFEST