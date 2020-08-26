#!/bin/bash

# if pass in any value, will pull images
norun=$1

echo "================================================================="
echo "Build simple-web-service"
echo "================================================================="
cd ../simple-web-service
./build.sh dtdemos/simple-web-service 0.1.0
cd ../scripts

echo "================================================================="
echo "Build simple-web-app"
echo "================================================================="
cd ../simple-web-app
./build.sh dtdemos/simple-web-app 0.1.0
cd ../scripts

if [ -z "$norun" ]; then
    echo "================================================================="
    echo "Start App"
    echo "================================================================="
    ./start-app.sh
fi
