#!/usr/bin/env bash

set -e

if ! command -v kubectl >/dev/null 2>&1; then
    echo "ERROR: 'kubectl' is required to configure a Kubernetes cluster on AWS with this script!"
    echo "       Installation instructions can be found here:"
    echo "       https://kubernetes.io/docs/tasks/tools/#kubectl"
    exit 1
fi

kubectl --namespace=default get pods

echo "If there are issues with any pods, you can get more details with:"
echo "  $ kubectl --namespace=default describe pod <pod-name>"