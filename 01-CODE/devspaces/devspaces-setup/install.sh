#Install Dev Spaces operator (might take up to 5 min to complete)
oc create -f ./01-CODE/devspaces/devspaces-setup/devspaces-sub.yaml
sleep 60
#Install Dev Spaces
oc create -f ./01-CODE/devspaces/devspaces-setup/devspaces-ns.yaml
oc create -f ./01-CODE/devspaces/devspaces-setup/checluster.yaml

#sleep 90
#Access your Dev Spaces
#oc get route devspaces -o template --template='{{.spec.host}}' -n openshift-devspaces
