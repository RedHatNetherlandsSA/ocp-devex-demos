# 5-minute demo: OpenShift GitOps
For more information, please see the [official product documentation](https://docs.openshift.com/container-platform/4.11/cicd/gitops/understanding-openshift-gitops.html).

## Table of Contents
- **[What is GitOps?](#what-is-gitops)**<br>
- **[Introduction to OpenShift GitOps](#introduction-to-openshift-gitops)**<br>
- **[Installing OpenShift GitOps](#installing-the-openshift-gitops-argo-cd-operator)**<br>
- **[Deploy a demo application](#deploy-a-demo-application)**<br>
- **[Create a GitOps repository](#deploy-a-demo-application)**<br>
- **[Key takeaways](#)**<br>

---
# What is GitOps?
GitOps is an approach to continuous delivery (CD) and treats Git as the single source of truth for everything, including infrastructure, platform, and application configurations. 
Teams can then take advantage of Git workflows to drive cluster operations and application delivery to enable predictable, more secure, and repeatable changes to clusters. 
At the same time, observability and visibility of the actual state are increased, and possible configuration drifts can be detected easily and immediately through the GitOps workflow. 
GitOps allows for maintaining full transparency through Git audit capabilities and provides a straightforward mechanism to roll back to any desired version across multiple OpenShift and Kubernetes clusters.

![OpenShift GitOps](../../graphics/gitops-02.png)

# Introduction to OpenShift GitOps

OpenShift GitOps is built around open-source project Argo CD as the declarative GitOps engine that enables GitOps workflows across multicluster OpenShift and Kubernetes infrastructure. 
Using Argo CD, teams can sync the state of OpenShift and Kubernetes clusters and applications with the content of the  Git repositories manually or automatically. 
Argo CD continuously compares the state of the clusters and the Git repositories to identify any drift and can automatically bring the cluster back to the desired state if any change is detected on the Git repository or the cluster. 
The auto-healing capabilities in Argo CD increase the security of the CD workflow by preventing undesired, unauthorized, or unvetted changes that might be performed directly on the cluster unintentionally or through security breaches.

![OpenShift GitOps](../../graphics/gitops-01.jpeg)

---

# Installing the OpenShift GitOps (Argo CD) operator

Since it’s supported by an Operator, OpenShift GitOps is very easy to install and upgrade.

1. Open the Administrator perspective of the web console and navigate to Operators → OperatorHub in the menu on the left.
2. Search for OpenShift GitOps, click the Red Hat OpenShift GitOps tile, and then click Install.

Red Hat OpenShift GitOps will be installed in all namespaces of the cluster.

![OpenShift GitOps](../../graphics/gitops-03.jpeg)

Note: If you dont want to use OpenShift Console GUI for installing Pipelines Operator, you can use [Red Hat COP GitOps Catalog](https://github.com/redhat-cop/gitops-catalog/tree/main/openshift-gitops-operator)

```shell
oc apply -k https://github.com/redhat-cop/gitops-catalog/openshift-gitops-operator/overlays/latest
```
```shell
subscription.operators.coreos.com/openshift-gitops-operator created
```

After the installation is complete, ensure that all the pods in the openshift-gitops namespace are running:
```shell
oc get pods -n openshift-gitops
```
The result should be similar to this:
```shell
NAME                                                          READY   STATUS    RESTARTS   AGE
cluster-7f59b69c56-rgpgb                                      1/1     Running   0          2m1s
kam-7694bd6c85-lngm7                                          1/1     Running   0          2m1s
openshift-gitops-application-controller-0                     1/1     Running   0          119s
openshift-gitops-applicationset-controller-69d7b598d5-mcnml   1/1     Running   0          119s
openshift-gitops-dex-server-b744ff94-x8q7m                    1/1     Running   0          2m
openshift-gitops-redis-794f4dbb9f-8mnmt                       1/1     Running   0          119s
openshift-gitops-repo-server-67bd56c86d-fdq4z                 1/1     Running   0          119s
openshift-gitops-server-699f794bb5-8qp2p                      1/1     Running   0          119s
```

## Login to Argo CD instance

Red Hat OpenShift GitOps Operator automatically creates a ready-to-use Argo CD instance that is available in the openshift-gitops namespace.

Get ARGO URL from the route in openshift-gitops project:
```shell
ARGO="http://$(oc get -n openshift-gitops route openshift-gitops-server -o jsonpath="{.spec.host}")"
```
Open ARGO in your browser:
```shell
open -a "Google Chrome" $ARGO
```
![OpenShift GitOps](../../graphics/gitops-04.jpeg)

---

# Deploy a demo application

## Let's set things up

- Login to OpenShift cluster
```shell
oc login -u myuser -p mypassword
```
- Create a new OpenShift project
```shell
oc new-project gitops-demo
```
- Verify that the project is empty
```shell
oc get all -n gitops-demo
```

## Deploy a .NET Core application from GitHub

For this exercise, we'll use an existing dotnet Hello World application. The source code of this application is made available via GitHub [repo](https://github.com/adnan-drina/s2i-dotnetcore-ex.git).

With the ``new-app`` command we'll create application from source code in a remote Git repository.

The ``new-app`` command creates a build configuration, which itself creates a new application image from our source code.
The ``new-app`` command typically also creates a Deployment object to deploy the new image, and a service to provide load-balanced access to the deployment running our image.

In addition, we'll have to expose our service by creating a route to access our application externally via a web browser.

### Let's create our app from the git repo
```shell
oc new-app --name=dotnet-demo 'dotnet:6.0-ubi8~https://github.com/redhat-developer/s2i-dotnetcore-ex#dotnet-6.0' \
--build-env DOTNET_STARTUP_PROJECT=app
```
Kubernetes resources created:
```shell
...
--> Creating resources ...
    imagestream.image.openshift.io "dotnet-demo" created
    buildconfig.build.openshift.io "dotnet-demo" created
    deployment.apps "dotnet-demo" created
    service "dotnet-demo" created
...
```

- View the status of the app
```shell
oc status
```
- Make the application accessible externally
```shell
oc expose service dotnet-demo
```

## Access the service using the Route URL
```shell
ROUTE="http://$(oc get route dotnet-demo -o jsonpath="{.spec.host}")" &&\
curl -s $ROUTE | grep Welcome
```
The result should be similar to this:
```shell
curl -s $ROUTE | grep Welcome
    <h1 class="display-4">Welcome</h1>
```
You can also view the app in your browser
```shell
open -a "Google Chrome" $ROUTE
```
---

# Create a GitOps repository

## Export YAMLs from our deployed demo app

In the previous steps, for our application deployment, we have used the `oc new-app` command that has "magically" created for our demo application Kubernetes resources such as Deployment, Service, etc.

Now, our first step in adopting GitOps practice will be to:
export all application configurations (YAML files) from our OpenShift cluster,
clear these files from unwanted metadata
and store them in git.

We can export all resources using `oc get all` command, like this:
```shell
oc get all -l app=dotnet-demo -o yaml > ./dotnet-demo.yaml
```
Once exported, we can manually remove unwanted metadata from the YAML file.

To speed things up, we have created shall scripts that will automate exporting and cleaning of Deployment, Service and Route resources.
After the successful execution of the scripts, all files will be available in the ./tmp folder, and we can copy them to our application gitops git repository.

```shell
./02-SHIP/gitops/export/01-deployment-export.sh gitops-demo dotnet-demo ./tmp/ &&\
./02-SHIP/gitops/export/02-service-export.sh gitops-demo dotnet-demo ./tmp/ &&\
./02-SHIP/gitops/export/03-route-export.sh gitops-demo dotnet-demo ./tmp/ 
```

### Create a GitOps repository


oc label namespace dotnet-demo-dev argocd.argoproj.io/managed-by=openshift-gitops






#### Key features

Red Hat OpenShift GitOps helps you automate the following tasks:

- Ensure that the clusters have similar states for configuration, monitoring, and storage
- Apply or revert configuration changes to multiple OpenShift Container Platform clusters
- Associate templated configuration with different environments
- Promote applications across clusters, from staging to production