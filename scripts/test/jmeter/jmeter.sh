#!/bin/bash

# adjust setup parameters
SERVER_NAME="$1"
SERVER_PORT="$2"
LOOP_COUNT="$3"
VU_COUNT="$4"
THINK_TIME="$5"

# do not edit
DT_LTN="manual_$(date +%Y-%m-%d_%H:%M:%S)"
#SUMMARY_FILENAME=summary.log
SCRIPT=load.jmx

# remove old logs
rm -f jmeter.log
rm -f $SUMMARY_FILENAME

echo "Start Time: $(date +%Y-%m-%d_%H:%M:%S)"

jmeter -n -t $SCRIPT \
  -JSERVER_NAME=$SERVER_NAME \
  -JSERVER_PORT=$SERVER_PORT \
  -JLOOP_COUNT=$LOOP_COUNT \
  -JVU_COUNT=$VU_COUNT \
  -JDT_LTN=$DT_LTN \
  -JTHINK_TIME=$THINK_TIME \
  -JSUMMARY_FILENAME=$SUMMARY_FILENAME

echo "End Time: $(date +%Y-%m-%d_%H:%M:%S)"
