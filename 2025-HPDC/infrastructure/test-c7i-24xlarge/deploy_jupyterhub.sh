#!/usr/bin/env bash

set -e

if ! command -v helm >/dev/null 2>&1; then
    echo "ERROR: 'helm' is required to configure and launch JupyterHub on AWS with this script!"
    echo "       Installation instructions can be found here:"
    echo "       https://helm.sh/docs/intro/install/"
    exit 1
fi

echo "Adding JupyterHub to EKS cluster using Helm:"
helm repo add jupyterhub https://hub.jupyter.org/helm-chart/
helm repo update
echo ""
echo "Installing the Helm chart and deploying JupyterHub to EKS:"
helm install hpdc-2025-c7i-24xlarge-jupyter jupyterhub/jupyterhub --version 4.2.0 --values /Users/lumsden1/projects/pave/hpdc-tutorial/hpdc-tutorial-docker-test/2025-HPDC/infrastructure/test-c7i-24xlarge/helm-config.yaml

echo ""
echo "Done deploying JupyterHub!"
echo ""
echo "Next, you should ensure all the pods spawned correctly with check_jupyterhub_status.sh,"
echo "and you should get the cluster URL with get_jupyterhub_url.sh."
echo ""
echo "If something went wrong, you can edit the helm-config.yaml file to try to fix the issue."
echo "After editing helm-config.yaml, you can normally reconfigure and relaunch JupyterHub using"
echo "the update_jupyterhub_deployment.sh script. If that doesn't work or if you need to edit"
echo "storage-class.yaml or cluster-autoscaler.yaml, you should first tear down JupyterHub with"
echo "tear_down_jupyterhub.sh, and then you should bring Jupyter back up by rerunning deploy_jupyterhub.sh."
echo ""
echo "If everything went smoothly, the cluster URL is what you should share with attendees."
echo ""
echo "Attendees can get a Jupyter environment to work in by going to that URL and logging in"
echo "with a username of their choice and the password specified in helm-config.yaml."
echo ""
echo "Note: users should have unique usernames. If two users have the same username, they will"
echo "      share the same pod."
echo ""
echo "After you are done with your tutorial, you should finally run cleanup.sh to bring down"
echo "the EKS cluster and all associated resources."