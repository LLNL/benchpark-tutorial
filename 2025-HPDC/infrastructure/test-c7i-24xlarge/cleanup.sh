#!/usr/bin/env bash

set -e

if ! command -v kubectl >/dev/null 2>&1; then
    echo "ERROR: 'kubectl' is required to configure a Kubernetes cluster on AWS with this script!"
    echo "       Installation instructions can be found here:"
    echo "       https://kubernetes.io/docs/tasks/tools/#kubectl"
    exit 1
fi

if ! command -v eksctl >/dev/null 2>&1; then
    echo "ERROR: 'eksctl' is required to create a Kubernetes cluster on AWS with this script!"
    echo "       Installation instructions can be found here:"
    echo "       https://eksctl.io/installation/"
    exit 1
fi

if ! command -v helm >/dev/null 2>&1; then
    echo "ERROR: 'helm' is required to configure and launch JupyterHub on AWS with this script!"
    echo "       Installation instructions can be found here:"
    echo "       https://helm.sh/docs/intro/install/"
    exit 1
fi

# Temporarily allow errors in the script so that the script won't fail
# if the JupyterHub deployment failed or was previously torn down
set +e
echo "Tearing down JupyterHub and uninstalling everything related to Helm:"
helm uninstall hpdc-2025-c7i-24xlarge-jupyter
set -e

echo ""
echo "Deleting all pods from the EKS cluster:"
kubectl delete pod --all-namespaces --all --force

echo ""
echo "Deleting the EKS cluster:"
eksctl delete cluster --config-file /Users/lumsden1/projects/pave/hpdc-tutorial/hpdc-tutorial-docker-test/2025-HPDC/infrastructure/test-c7i-24xlarge/eksctl-config.yaml --wait

echo ""
echo "Everything is now cleaned up!"