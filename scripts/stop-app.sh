#!/bin/bash

function stop-container() {
  name=$1

  containers=$(sudo docker ps -a -q --filter="name=$name")
  if [[ "$containers" != "" ]]; then
    echo "Deleting $name containers: $containers"
    sudo docker stop $containers
    sudo docker rm $containers
  else
    echo "Skipping delete of $name"
  fi
}

# Main routine
stop-container service-1
stop-container service-2
stop-container service-3
stop-container simple-web-app

sudo docker ps