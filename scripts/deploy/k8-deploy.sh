#!/bin/bash

NAMESPACE=demo-app-dev
kubectl create ns $NAMESPACE
kubectl apply -f k8/ -n $NAMESPACE

echo ""
echo "Sleeping 30 seconds to allow services to comeup..."
sleep 30

echo ""
echo "==========================================================="
echo "kubectl -n $NAMESPACE get pods"
echo "==========================================================="
kubectl -n $NAMESPACE get pods

echo ""
echo "==========================================================="
echo "kubectl -n $NAMESPACE get svc"
echo "==========================================================="
kubectl -n $NAMESPACE get svc