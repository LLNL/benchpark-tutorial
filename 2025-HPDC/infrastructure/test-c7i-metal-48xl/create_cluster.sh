#!/usr/bin/env bash

set -e

if ! command -v eksctl >/dev/null 2>&1; then
    echo "ERROR: 'eksctl' is required to create a Kubernetes cluster on AWS with this script!"
    echo "       Installation instructions can be found here:"
    echo "       https://eksctl.io/installation/"
    exit 1
fi

echo "Creating EKS cluster with eksctl:"
eksctl create cluster --config-file /Users/lumsden1/projects/pave/hpdc-tutorial/hpdc-tutorial-docker-test/2025-HPDC/infrastructure/test-c7i-metal-48xl/eksctl-config.yaml

echo "Done creating the EKS cluster!"
echo ""
echo "Next, you should run configure_kubernetes.sh to configure Kubernetes on the cluster."