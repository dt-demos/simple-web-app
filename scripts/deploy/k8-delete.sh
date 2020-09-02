#!/bin/bash

NAMESPACE=demo-app-dev
kubectl delete $NAMESPACE

echo "==========================================================="
echo "kubectl get ns"
echo "==========================================================="
kubectl get ns