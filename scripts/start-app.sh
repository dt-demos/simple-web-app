#!/bin/bash

# if pass in any value, will not pull images
nopull=$1

function start-container() {
  image=$1
  port=$2
  url=$3
  name=$4
  servicetag=$5
  dtcustomprop="stage=dev project=demo service=$servicetag"

  echo "Removing dangling images"
  docker rmi $(docker images -f "dangling=true" -q)

  if [ -z "$nopull" ]; then
    echo "Checking to see use have the latest image $image"
    sudo docker pull $image
  fi

  echo "Running image: $image  container name: $name dt-custom-prop: $dtcustomprop"  
  sudo docker run -p $port:8080 -d \
    --name $name \
    -e SERVICE_TO_CALL_URL=$url \
    -e DT_CUSTOM_PROP="$dtcustomprop" \
    $image
}

# Main routine
./stop-app.sh

# 172.17.0.1 is the IP that Docker container sees for the host it runs on
start-container dtdemos/simple-web-service-1:0.1.0 8180 http://172.17.0.1:8280/api/message service-1 simple-web-service-1
start-container dtdemos/simple-web-service-2:0.1.0 8280 http://172.17.0.1:8380/api/message service-2 simple-web-service-2
start-container dtdemos/simple-web-service-3:0.1.0 8380 none service-3 simple-web-service-3
start-container dtdemos/simple-web-app:0.1.0 8080 http://172.17.0.1:8180/api/message simple-web-app simple-web-app

sudo docker ps