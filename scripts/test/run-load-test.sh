#!/bin/bash

JMETER_FILE=jmeter.json
if ! [ -f "$JMETER_FILE" ]; then
  echo "ERROR: missing $JMETER_FILE"
  exit 1
fi

SERVER_NAME1=$(cat $JMETER_FILE | jq -r '.SERVER_NAME1')
SERVER_PORT1=$(cat $JMETER_FILE | jq -r '.SERVER_PORT1')
SERVER_NAME2=$(cat $JMETER_FILE | jq -r '.SERVER_NAME2')
SERVER_PORT2=$(cat $JMETER_FILE | jq -r '.SERVER_PORT2')
LOOP_COUNT=$(cat $JMETER_FILE | jq -r '.LOOP_COUNT')
VU_COUNT=$(cat $JMETER_FILE | jq -r '.VU_COUNT')
THINK_TIME=$(cat $JMETER_FILE | jq -r '.THINK_TIME')
DT_LTN="manual_$(date +%Y-%m-%d_%H:%M:%S)"

function send-test-event() {

  TITLE="Load-Test-Start"
  DESCRIPTION="Demo-Load-Test-Event"
  PROJECT_TAG=demo
  STAGE_TAG=dev

  cd ../dynatrace
  echo "calling send-dt-custom-test-event.sh"
  ./send-dt-custom-test-event.sh $TITLE $DESCRIPTION $PROJECT_TAG $STAGE_TAG
  cd ../test
}

function run-jmeter-test() {

echo "calling jmeter.sh"
cd ./jmeter
./jmeter.sh $SERVER_NAME1 $SERVER_PORT1 $SERVER_NAME2 $SERVER_PORT2 $LOOP_COUNT $VU_COUNT $THINK_TIME $DT_LTN
cd ..

}

# Main routine
send-test-event
run-jmeter-test
