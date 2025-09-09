#!/usr/bin/env bash

set -e

if ! command -v kubectl >/dev/null 2>&1; then
    echo "ERROR: 'kubectl' is required to configure a Kubernetes cluster on AWS with this script!"
    echo "       Installation instructions can be found here:"
    echo "       https://kubernetes.io/docs/tasks/tools/#kubectl"
    exit 1
fi

hub_pod_id=$(kubectl get pods -n default --no-headers=true | awk '/hub/{print $1}')
kubectl logs $hub_pod_id