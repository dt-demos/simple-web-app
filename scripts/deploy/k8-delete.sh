#!/bin/bash

NAMESPACE=demo-app-dev
kubectl delete ns $NAMESPACE

echo "==========================================================="
echo "kubectl get ns"
echo "==========================================================="
kubectl get ns