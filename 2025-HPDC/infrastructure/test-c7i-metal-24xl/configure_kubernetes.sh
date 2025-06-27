#!/usr/bin/env bash

set -e

if ! command -v kubectl >/dev/null 2>&1; then
    echo "ERROR: 'kubectl' is required to configure a Kubernetes cluster on AWS with this script!"
    echo "       Installation instructions can be found here:"
    echo "       https://kubernetes.io/docs/tasks/tools/#kubectl"
    exit 1
fi

echo "Configuring the Cluster Autoscaler:"
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"
kubectl apply -f /Users/lumsden1/projects/pave/hpdc-tutorial/hpdc-tutorial-docker-test/2025-HPDC/infrastructure/test-c7i-metal-24xl/cluster-autoscaler.yaml
echo ""
echo "Configuring the Storage Class:"
kubectl apply -f /Users/lumsden1/projects/pave/hpdc-tutorial/hpdc-tutorial-docker-test/2025-HPDC/infrastructure/test-c7i-metal-24xl/storage-class.yaml

echo ""
echo "Patching the cluster to make the configured storage class the default:"
kubectl patch storageclass gp3 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'

echo ""
echo "Done configuring Kubernetes!"
echo ""
echo "Next, you should run deploy_jupyterhub.sh to actually deploy JupyterHub and the tutorial."