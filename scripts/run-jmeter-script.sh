#!/bin/bash

CREDS_FILE=creds.json
if ! [ -f "$CREDS_FILE" ]; then
  echo "ERROR: missing $CREDS_FILE"
  exit 1
fi

WEB_APP_DOMAIN=$1
WEB_APP_PORT=$2

if [ -z "$WEB_APP_DOMAIN" ]; then
  echo "ERROR: missing WEB_APP_DOMAIN argument"
  echo "Example: ./run-jmeter-script.sh 111.222.333.444 8080"
  exit 1
fi

if [ -z "$WEB_APP_PORT" ]; then
  echo "ERROR: missing WEB_APP_PORT argument"
  echo "Example: ./run-jmeter-script.sh 111.222.333.444 8080"
  exit 1
fi

DYNATRACE_BASE_URL=$(cat $CREDS_FILE | jq -r '.DYNATRACE_BASE_URL')
DYNATRACE_API_TOKEN=$(cat $CREDS_FILE | jq -r '.DYNATRACE_API_TOKEN')

LOOP_COUNT=14400 # NOTE: 14400=60min
VU_COUNT=3
THINK_TIME=250

function send-test-event() {

  TITLE="Load-Test-Start"
  DESCRIPTION="Demo-Load-Test-Event"

  PROJECT_TAG=demo
  STAGE_TAG=dev

  cd ./dynatrace
  ./send-custom-test-event.sh $DYNATRACE_BASE_URL $DYNATRACE_API_TOKEN $TITLE $DESCRIPTION $PROJECT_TAG $STAGE_TAG
  cd ..
}

function run-jmeter-test() {

cd ./jmeter
./jmeter.sh $WEB_APP_DOMAIN $WEB_APP_PORT $LOOP_COUNT $VU_COUNT $THINK_TIME
cd ..

}

# Main routine
send-test-event
run-jmeter-test
