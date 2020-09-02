#!/bin/bash

# Unix Shell script to send an create Dynatrace deployment API call 
# Assumes that will tag entities with an "project", "stage" and "service" TAG

DYNATRACE_BASE_URL="$1"
DYNATRACE_API_TOKEN="$2"

RELEASE_DEFINITION_NAME="$3"
RELEASE_ID="$4"
RELEASE_TEAM_PROJECT="$5"
RELEASE_URL="$6"

PROJECT_TAG="$7"
STAGE_TAG="$8"
SERVICE_TAG="$9"

# derived value
DYNATRACE_API_URL="$1/api/v1/events"

echo "================================================================="
echo "Dynatrace Deployment event:"
echo ""
echo "DYNATRACE_BASE_URL         = $DYNATRACE_BASE_URL"
echo "DYNATRACE_API_URL          = $DYNATRACE_API_URL"
echo "RELEASE_DEFINITION_NAME    = $RELEASE_DEFINITION_NAME"
echo "RELEASE_ID                 = $RELEASE_ID"
echo "RELEASE_TEAM_PROJECT       = $RELEASE_TEAM_PROJECT"
echo "RELEASE_URL                = $RELEASE_URL"
echo "PROJECT_TAG                = $PROJECT_TAG"
echo "STAGE_TAG                  = $STAGE_TAG"
echo "SERVICE_TAG                = $SERVICE_TAG"
echo "================================================================="

POST_DATA=$(cat <<EOF
    {
        "eventType" : "CUSTOM_DEPLOYMENT",
        "source" : "send-deploy-event script" ,
        "deploymentName" : "$RELEASE_DEFINITION_NAME",
        "deploymentVersion" : "$RELEASE_ID"  ,
        "deploymentProject" : "$RELEASE_TEAM_PROJECT" ,
        "ciBackLink" : "$RELEASE_URL",
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
                                "key": "service",
                                "value" : "$SERVICE_TAG"    
                            },
                            {
                                "context" : "CONTEXTLESS",
                                "key": "project",
                                "value" : "$PROJECT_TAG"    
                            }
                            ]
                   }
                   ]
        }
    }
EOF)
echo $POST_DATA
curl --url "$DYNATRACE_API_URL" -H "Content-type: application/json" -H "Authorization: Api-Token "$DYNATRACE_API_TOKEN -X POST -d "$POST_DATA"