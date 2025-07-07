#!/usr/bin/env bash

set -e

if ! command -v helm >/dev/null 2>&1; then
    echo "ERROR: 'helm' is required to configure and launch JupyterHub on AWS with this script!"
    echo "       Installation instructions can be found here:"
    echo "       https://helm.sh/docs/intro/install/"
    exit 1
fi

helm uninstall hpdc-2025-c7i-48xlarge-jupyter

echo "Helm's JupyterHub deployment is torn down."
echo "If any attendee pods are remaining, you can delete them with `kubectl delete pod <pod_name>`"
echo ""
echo "To recreate the JupyterHub deployment, just run deploy_jupyterhub.sh again."