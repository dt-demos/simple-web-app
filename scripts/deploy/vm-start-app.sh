#!/bin/bash

nameprefix=$1
# if pass in any value, will not pull images -- do this when developing locally
nopull=$2

function start-container() {
  image=$1
  port=$2
  url=$3
  name=$4
  stagetag=$5
  projecttag=$6
  servicetag=$7
  dtcustomprop="stage=$stagetag project=$projecttag service=$servicetag"

  if [ -z "$nopull" ]; then
    echo "Removing dangling images"
    sudo docker rmi $(docker images -f "dangling=true" -q)
    echo "Checking to see use have the latest image $image"
    sudo docker pull $image
  fi

  echo "Running image: $image  container name: $name dt-custom-prop: $dtcustomprop"  
  sudo docker run -p $port:8080 -d \
    --name $name \
    -e SERVICE_NAME=$nameprefix$name \
    -e SERVICE_TO_CALL_URL=$url \
    -e DT_CUSTOM_PROP="$dtcustomprop" \
    $image
}

# Main routine
./vm-stop-app.sh

if [ -z $nameprefix ]; then
  nameprefix=""
else
  nameprefix="$nameprefix-"
fi

# 172.17.0.1 is the IP that Docker cosntainer sees for the host it runs on
start-container dtdemos/simple-web-service-1:0.1.0 8180 http://172.17.0.1:8280/api/message simple-web-service-1 dev demo simple-web-service-1
start-container dtdemos/simple-web-service-2:0.1.0 8280 http://172.17.0.1:8380/api/message simple-web-service-2 dev demo simple-web-service-2
start-container dtdemos/simple-web-service-3:0.1.0 8380 http://172.17.0.1:8480/api/message simple-web-service-3 dev demo simple-web-service-3
start-container dtdemos/simple-web-service-4:0.1.0 8480 http://172.17.0.1:8580/api/message simple-web-service-4 dev demo simple-web-service-4
start-container dtdemos/simple-web-service-5:0.1.0 8580 none                               simple-web-service-5 dev demo simple-web-service-5
start-container dtdemos/simple-web-app-1:0.1.0     8080 http://172.17.0.1:8180/api/message simple-web-app-1     dev demo simple-web-app-1
start-container dtdemos/simple-web-app-2:0.1.0     8090 http://172.17.0.1:8180/api/message simple-web-app-2     dev demo simple-web-app-2

sudo docker ps 