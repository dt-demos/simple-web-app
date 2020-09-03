#!/bin/bash

CREDS_FILE=creds.json
if ! [ -f "$CREDS_FILE" ]; then
  echo "ERROR: missing $CREDS_FILE"
  exit 1
fi

if [[ $# -lt 3 ]]; then
  echo "Abort: Missing arguments"
  echo "./send-dt-deployment-event.sh PROJECT_TAG STAGE_TAG SERVICE_TAG (optional RELEASE_ID)"
  exit 1
fi

PROJECT_TAG=$1
STAGE_TAG=$2
SERVICE_TAG=$3
RELEASE_TEAM_PROJECT="my-release-team"
RELEASE_URL="http://fakeurl-to-ci-cd-job"

# optional pass in the release number
if [ $# -lt 4 ]
then
  RELEASE_ID=1
else
  RELEASE_ID=$4
fi

RELEASE_DEFINITION_NAME="Deploy-release-$RELEASE_ID"
PROJECT_TAG=demo
STAGE_TAG=dev
DYNATRACE_BASE_URL=$(cat $CREDS_FILE | jq -r '.DYNATRACE_BASE_URL')
DYNATRACE_API_TOKEN=$(cat $CREDS_FILE | jq -r '.DYNATRACE_API_TOKEN')

function send-deploy-event() {

  ./_send-deploy-event.sh \
    $DYNATRACE_BASE_URL \
    $DYNATRACE_API_TOKEN \
    $RELEASE_DEFINITION_NAME \
    $RELEASE_ID \
    $RELEASE_TEAM_PROJECT \
    $RELEASE_URL \
    $PROJECT_TAG \
    $STAGE_TAG \
    $SERVICE_TAG
}

# Main routine
send-deploy-event
