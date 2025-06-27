# Deploy hpdc-2025-c7i-48xlarge to AWS Elastic Kubernetes Service (EKS)

These config files and scripts can be used to deploy the hpdc-2025-c7i-48xlarge tutorial to EKS.

The sections below walk you through the steps to deploying your cluster. All commands in these
sections should be run from the `/Users/lumsden1/projects/pave/hpdc-tutorial/hpdc-tutorial-docker-test/2025-HPDC/infrastructure/test-c7i-48xlarge` directory.

## Step 1: Create EKS cluster

To create an EKS cluster with your configured settings, run the following:

```bash
$ ./create_cluster.sh
```

Be aware that this step can take upwards of 15-30 minutes to complete.

## Step 2: Configure Kubernetes within the EKS cluster

After creating the cluster, we need to configure Kubernetes and its addons. In particular,
we need to setup the Kubernetes autoscaler, which will allow our tutorial to scale to as
many users as our cluster's resources can possibly handle.

To configure Kubernetes and the autoscaler, run the following:

```bash
$ ./configure_kubernetes.sh
```

## Step 3: Deploy JupyterHub to the EKS cluster

With the cluster properly created and configured, we now can deploy JupyterHub to the cluster
to manage everything else about our tutorial.

To deploy JupyterHub, run the following:

```bash
$ ./deploy_jupyterhub.sh
```

## Step 4: Verify that everything is working

After deploying JupyterHub, we need to make sure that all the necessary components
are working properly.

To check this, run the following:

```bash
$ ./check_jupyterhub_status.sh
```

If everything worked properly, you should see an output like this:

```
NAME                              READY   STATUS    RESTARTS   AGE
continuous-image-puller-2gqrw     1/1     Running   0          30s
continuous-image-puller-gb7mj     1/1     Running   0          30s
hub-8446c9d589-vgjlw              1/1     Running   0          30s
proxy-7d98df9f7-s5gft             1/1     Running   0          30s
user-scheduler-668ff95ccf-fw6wv   1/1     Running   0          30s
user-scheduler-668ff95ccf-wq5xp   1/1     Running   0          30s
```

Be aware that the hub pod (i.e., hub-8446c9d589-vgjlw above) may take a minute or so to start.

If something went wrong, you will have to edit the config YAML files to get things working. Before
trying to work things out yourself, check the FAQ to see if your issue has already been addressed.

Depending on what file you edit, you may have to run different commands to update the EKS cluster and
deployment of JupyterHub. Follow the steps below to update:
1. If you only edited `helm-config.yaml`, try to just update the deployment of Jupyterhub by running `./update_jupyterhub_deployment.sh`
2. If step 1 failed, fully tear down the JupyterHub deployment with `./tear_down_jupyterhub.sh` and then re-deploy it with `./deploy_jupyterhub.sh`
3. If you edited `cluster-autoscaler.yaml` or `storage-class.yaml`, tear down the JupyterHub deployment with `./tear_down_jupyterhub.sh`. Then, reconfigure Kubernetes with `./configure_kubernetes.sh`, and re-deploy JupyterHub with `./deploy_jupyterhub.sh`
4. If you edited `eksctl-config.yaml`, fully tear down the cluster with `cleanup.sh`, and then restart from the top of this README 

## Step 5: Get the public cluster URL

Now that everything's ready to go, we need to get the public URL to the cluster.

To do this, run the following:

```bash
$ ./get_jupyterhub_url.sh
```

Note that it can take several minutes after the URL is available for it to actually redirect
to JupyterHub.

## Step 6: Distribute URL and password to attendees

Now that we have our pulbic URL, we can give the attendees everything they need to join the tutorial.

For attendees to access JupyterHub, they simply need to enter the public URL (from step 5) in their browser of choice.
This will take them to a login page. The login credentials are as follows:
* Username: anything the attendee wants (note: this should be unique for every user. Otherwise, users will share pods.)
* Password: the password specified towards the top of `helm-config.yaml`

Once the attendees log in with these credentials, the Kubernetes autoscaler will spin up a pod for them (and grab new
resources, if needed). This pod will contain a JupyterLab instace with the tutorial materials and environment already
prepared for them.

At this point, you can start presenting your interactive tutorial!

## Step 7: Cleanup everything

Once you are done with your tutorial, you should cleanup everything so that there are not continuing, unneccesary expenses
to your AWS account. To do this, simply run the following:

```bash
$ ./cleanup.sh
```

After cleaning everything up, you can verify that everything has been cleaned up by going to the AWS web consle
and ensuring nothing from your tutorial still exists in CloudFormation and EKS.