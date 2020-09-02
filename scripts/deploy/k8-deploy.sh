#!/bin/bash

NAMESPACE=demo-app-dev
kubectl create $NAMESPACE
kubectl apply -f k8/ -n $NAMESPACE

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