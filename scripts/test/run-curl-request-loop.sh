#!/bin/bash

###################################################
# process arguments
###################################################

# get the URL
if [ $# -lt 1 ]
then
  echo "missing arguments. Expect URL as an argument"
  echo "example: ./run-curl-request-loop.sh http://someurl"
  exit 1
fi
url=$1

# number of seconds
if [ $# -lt 2 ]
then
  duration=120
else
  duration=$2 
fi

# default the test name to the date.  Can pass it in build number when running from a pipeline
if [ $# -lt 3 ]
then
  loadTestName="manual $(date +%Y-%m-%d_%H:%M:%S)"
else
  loadTestName=$3
fi

###################################################
# set variables used by script
###################################################

# Set Dynatrace Test Headers Values
loadScriptName="sendtraffic.sh"

# Calculate how long this test maximum runs!
thinktime=1  # default the think time
currTime=`date +%s`
timeSpan=$duration
endTime=$(($timeSpan+$currTime))

###################################################
# Run test
###################################################

echo "Load Test Started. NAME: $loadTestName"
echo "DURATION=$duration URL=$url THINKTIME=$thinktime"
echo "x-dynatrace-test: LSN=$loadScriptName;LTN=$loadTestName;"
echo ""

# loop until run out of time.  use thinktime between loops
ctr=0
while [ $currTime -lt $endTime ];
do
  currTime=`date +%s`
  echo "Loop $ctr Start: $(date +%H:%M:%S)"
  
  testStepName=home
  echo "  calling TSN=$testStepName; $(curl -s "$url:8080" -w "%{http_code}; %{time_total}" -H "x-dynatrace-test: LSN=$loadScriptName;LTN=$loadTestName;TSN=$testStepName;" -o /dev/nul)"
  echo "  calling TSN=$testStepName; $(curl -s "$url:8090" -w "%{http_code}; %{time_total}" -H "x-dynatrace-test: LSN=$loadScriptName;LTN=$loadTestName;TSN=$testStepName;" -o /dev/nul)"

  #testStepName=message
  #echo "  calling TSN=$testStepName; $(curl -s "$url:8180/api/message" -w "%{http_code}; %{time_total}" -H "x-dynatrace-test: LSN=$loadScriptName;LTN=$loadTestName;TSN=$testStepName;" -o /dev/nul)"
  #echo "  calling TSN=$testStepName; $(curl -s "$url:8280/api/message" -w "%{http_code}; %{time_total}" -H "x-dynatrace-test: LSN=$loadScriptName;LTN=$loadTestName;TSN=$testStepName;" -o /dev/nul)"
  #echo "  calling TSN=$testStepName; $(curl -s "$url:8380/api/message" -w "%{http_code}; %{time_total}" -H "x-dynatrace-test: LSN=$loadScriptName;LTN=$loadTestName;TSN=$testStepName;" -o /dev/nul)"
  #echo "  calling TSN=$testStepName; $(curl -s "$url:8480/api/message" -w "%{http_code}; %{time_total}" -H "x-dynatrace-test: LSN=$loadScriptName;LTN=$loadTestName;TSN=$testStepName;" -o /dev/nul)"
  #echo "  calling TSN=$testStepName; $(curl -s "$url:8580/api/message" -w "%{http_code}; %{time_total}" -H "x-dynatrace-test: LSN=$loadScriptName;LTN=$loadTestName;TSN=$testStepName;" -o /dev/nul)"

  sleep $thinktime
  ctr=`expr $ctr + 1`

done;

echo Done.
