#!/bin/bash

echo "================================================================="
echo "Push simple-web-service"
echo "================================================================="
cd ../simple-web-service
./push.sh dtdemos/simple-web-service 0.1.0
cd ../scripts

echo "================================================================="
echo "Push simple-web-app"
echo "================================================================="
cd ../simple-web-app
./push.sh dtdemos/simple-web-app 0.1.0
cd ../scripts
