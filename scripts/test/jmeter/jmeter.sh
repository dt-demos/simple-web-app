#!/bin/bash

# adjust setup parameters
SERVER_NAME1="$1"
SERVER_PORT1="$2"
SERVER_NAME2="$3"
SERVER_PORT2="$4"
LOOP_COUNT="$5"
VU_COUNT="$6"
THINK_TIME="$7"
DT_LTN="$8"

#SUMMARY_FILENAME=summary.log
SCRIPT=load.jmx

# remove old logs
rm -f jmeter.log
rm -f $SUMMARY_FILENAME

echo "================================================================="
echo "Running Jmeter"
echo ""
echo "SERVER_NAME1  = $SERVER_NAME1"
echo "SERVER_PORT1  = $SERVER_PORT1"
echo "SERVER_NAME2  = $SERVER_NAME2"
echo "SERVER_PORT2  = $SERVER_PORT2"
echo "LOOP_COUNT    = $LOOP_COUNT"
echo "VU_COUNT      = $VU_COUNT"
echo "THINK_TIME    = $THINK_TIME"
echo "DT_LTN        = $DT_LTN"
echo "================================================================="
echo "Start Time: $(date +%Y-%m-%d_%H:%M:%S)"

jmeter -n -t $SCRIPT \
  -JSERVER_NAME1=$SERVER_NAME1 \
  -JSERVER_PORT1=$SERVER_PORT1 \
  -JSERVER_NAME2=$SERVER_NAME2 \
  -JSERVER_PORT2=$SERVER_PORT2 \
  -JLOOP_COUNT=$LOOP_COUNT \
  -JVU_COUNT=$VU_COUNT \
  -JDT_LTN=$DT_LTN \
  -JTHINK_TIME=$THINK_TIME \
  -JSUMMARY_FILENAME=$SUMMARY_FILENAME

echo "End Time: $(date +%Y-%m-%d_%H:%M:%S)"
