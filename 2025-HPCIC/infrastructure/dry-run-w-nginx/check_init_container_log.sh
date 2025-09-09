#!/usr/bin/env bash

set -e

if ! command -v kubectl >/dev/null 2>&1; then
    echo "ERROR: 'kubectl' is required to configure a Kubernetes cluster on AWS with this script!"
    echo "       Installation instructions can be found here:"
    echo "       https://kubernetes.io/docs/tasks/tools/#kubectl"
    exit 1
fi

if [ $# -ne 1 ]; then
    echo "Usage: ./check_init_container_log.sh <pod_name>"
    exit 1
fi

kubectl logs $1 -c init-tutorial-service