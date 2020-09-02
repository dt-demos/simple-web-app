#!/bin/bash

numapp=2
numweb=5

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
for imageid in $(eval echo "{1..$numapp}")
do
  stop-container simple-web-app-$imageid
done

for imageid in $(eval echo "{1..$numweb}")
do
  stop-container simple-web-service-$imageid
done

sudo docker ps