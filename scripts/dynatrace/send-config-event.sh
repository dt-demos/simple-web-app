#!/bin/bash

# Unix Shell script to send an create Dynatrace deployment API call 
# Assumes that will tag entities with an "project", "stage" and "service" TAG

DYNATRACE_BASE_URL="$1"
DYNATRACE_API_TOKEN="$2"

CONFIGURATION="$3"
DESCRIPTION="$4"

PROJECT_TAG="$5"
STAGE_TAG="$6"
SERVICE_TAG="$7"

# derived value
DYNATRACE_API_URL="$1/api/v1/events"

echo "================================================================="
echo "Dynatrace Configuration Info event:"
echo ""
echo "DYNATRACE_BASE_URL         = $DYNATRACE_BASE_URL"
echo "DYNATRACE_API_URL          = $DYNATRACE_API_URL"
echo "CONFIGURATION              = $CONFIGURATION"
echo "DESCRIPTION                = $DESCRIPTION"
echo "PROJECT_TAG                = $PROJECT_TAG"
echo "STAGE_TAG                  = $STAGE_TAG"
echo "SERVICE_TAG                = $SERVICE_TAG"
echo "================================================================="

POST_DATA=$(cat <<EOF
    {
        "eventType" : "CUSTOM_CONFIGURATION",
        "source" : "testevent.sh" ,
        "configuration" : "$CONFIGURATION",
        "description" : "$DESCRIPTION"  ,
        "attachRules" : {
               "tagRule" : [
                   {
                        "meTypes":"SERVICE" ,
                        "tags" : [
                            {
                                "context" : "CONTEXTLESS",
                                "key": "stage",
                                "value" : "$STAGE_TAG"    
                            },
                            {
                                "context" : "CONTEXTLESS",
                                "key": "project",
                                "value" : "$PROJECT_TAG"    
                            },
                            {
                                "context" : "CONTEXTLESS",
                                "key": "service",
                                "value" : "$SERVICE_TAG"    
                            }
                            ]
                   }
                   ]
        }
    }
EOF)
echo $POST_DATA
curl --url "$DYNATRACE_API_URL" -H "Content-type: application/json" -H "Authorization: Api-Token "$DYNATRACE_API_TOKEN -X POST -d "$POST_DATA"