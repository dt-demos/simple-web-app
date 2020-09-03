#!/bin/bash

CREDS_FILE=creds.json
if ! [ -f "$CREDS_FILE" ]; then
  echo "ERROR: missing $CREDS_FILE"
  exit 1
fi

if [[ $# -lt 3 ]]; then
  echo "Abort: Missing arguments"
  echo "./send-dt-config-event.sh PROJECT_TAG STAGE_TAG SERVICE_TAG (optional DESCRIPTION)"
  exit 1
fi

PROJECT_TAG=$1
STAGE_TAG=$2
SERVICE_TAG=$3

# optional pass in the configuration description
if [ $# -lt 4 ]
then
  DESCRIPTION="demo"
else
  DESCRIPTION=$4
fi

CONFIGURATION=$DESCRIPTION
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
