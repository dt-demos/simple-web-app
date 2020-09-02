#!/bin/bash

CREDS_FILE=creds.json
if ! [ -f "$CREDS_FILE" ]; then
  echo "ERROR: missing $CREDS_FILE"
  exit 1
fi

# optional pass in the release number
if [ $# -lt 1 ]
then
  DESCRIPTION="demo"
else
  DESCRIPTION=$1
fi

# optional pass in the service name
if [ $# -lt 2 ]
then
  SERVICE_TAG=simple-web-app-1
else
  SERVICE_TAG=$2
fi

CONFIGURATION=$DESCRIPTION
PROJECT_TAG=demo
STAGE_TAG=dev
DYNATRACE_BASE_URL=$(cat $CREDS_FILE | jq -r '.DYNATRACE_BASE_URL')
DYNATRACE_API_TOKEN=$(cat $CREDS_FILE | jq -r '.DYNATRACE_API_TOKEN')

function send-config-event() {

  ./_send-config-event.sh \
    $DYNATRACE_BASE_URL \
    $DYNATRACE_API_TOKEN \
    $CONFIGURATION \
    $DESCRIPTION \
    $PROJECT_TAG \
    $STAGE_TAG \
    $SERVICE_TAG

}

# Main routine
send-config-event
