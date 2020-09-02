#!/bin/bash

numapp=2
numweb=5

echo "================================================================="
echo "Building $numapp images of simple-web-app"
echo "================================================================="
cd ../../simple-web-app
./build.sh dtdemos/simple-web-app 0.1.0 $numapp
cd ../scripts/build

echo "================================================================="
echo "Building $numweb images of simple-web-service"
echo "================================================================="
cd ../../simple-web-service
./build.sh dtdemos/simple-web-service 0.1.0 $numweb
cd ../scripts/build
