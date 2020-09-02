#!/bin/bash

CREDS_FILE=creds.json
if ! [ -f "$CREDS_FILE" ]; then
  echo "ERROR: missing $CREDS_FILE"
  exit 1
fi

# optional pass in the release number
if [ $# -lt 1 ]
then
  RELEASE_ID=1
else
  RELEASE_ID=$1
fi

# optional pass in the service name
if [ $# -lt 2 ]
then
  SERVICE_TAG=simple-web-app-1
else
  SERVICE_TAG=$2
fi

RELEASE_DEFINITION_NAME="Deploy-release-$RELEASE_ID"
RELEASE_TEAM_PROJECT="apples"
RELEASE_URL="http://fakeurl-to-ci-cd-job"
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
