#!/usr/bin/env bash

set -e

if ! command -v helm >/dev/null 2>&1; then
    echo "ERROR: 'helm' is required to configure and launch JupyterHub on AWS with this script!"
    echo "       Installation instructions can be found here:"
    echo "       https://helm.sh/docs/intro/install/"
    exit 1
fi

helm upgrade hpdc-2025-c7i-metal-48xl-jupyter jupyterhub/jupyterhub  --values ./helm-config.yaml

echo "The JupyterHub deployment is updated!"