#!/bin/bash

CREDS_FILE=creds.json
if ! [ -f "$CREDS_FILE" ]; then
  echo "ERROR: missing $CREDS_FILE"
  exit 1
fi

# optional pass in the description
if [ $# -lt 1 ]
then
  DESCRIPTION="Load test start"
else
  DESCRIPTION=$1
fi

TITLE=$DESCRIPTION
PROJECT_TAG=demo
STAGE_TAG=dev
DYNATRACE_BASE_URL=$(cat $CREDS_FILE | jq -r '.DYNATRACE_BASE_URL')
DYNATRACE_API_TOKEN=$(cat $CREDS_FILE | jq -r '.DYNATRACE_API_TOKEN')

function custom-test-event() {

  ./_send-custom-test-event.sh \
    $DYNATRACE_BASE_URL \
    $DYNATRACE_API_TOKEN \
    $TITLE \
    $DESCRIPTION \
    $PROJECT_TAG \
    $STAGE_TAG

}

# Main routine
custom-test-event
