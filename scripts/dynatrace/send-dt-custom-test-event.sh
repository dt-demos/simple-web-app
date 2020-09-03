#!/bin/bash

CREDS_FILE=creds.json
if ! [ -f "$CREDS_FILE" ]; then
  echo "ERROR: missing $CREDS_FILE"
  exit 1
fi

DYNATRACE_BASE_URL=$(cat $CREDS_FILE | jq -r '.DYNATRACE_BASE_URL')
DYNATRACE_API_TOKEN=$(cat $CREDS_FILE | jq -r '.DYNATRACE_API_TOKEN')

if [[ $# -ne 4 ]]; then
  echo "Abort: Missing arguments"
  echo "./send-dt-custom-test-event.sh TITLE DESCRIPTION PROJECT_TAG STAGE_TAG"
  exit 1
fi

TITLE=$1
DESCRIPTION=$2
PROJECT_TAG=$3
STAGE_TAG=$4

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
