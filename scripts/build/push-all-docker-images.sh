#!/bin/bash

numapp=2
numweb=5

echo "================================================================="
echo "Push simple-web-app"
echo "================================================================="
cd ../../simple-web-app
./push.sh dtdemos/simple-web-app 0.1.0 $numapp
cd ../scripts/build

echo "================================================================="
echo "Push simple-web-service"
echo "================================================================="
cd ../../simple-web-service
./push.sh dtdemos/simple-web-service 0.1.0 $numweb
cd ../scripts/build
