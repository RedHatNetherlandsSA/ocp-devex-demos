#!/bin/bash

PROJECT=$1
NAME=$2
EXPORT_DIR=$3

## Deployment
oc get deployment ${NAME} -n ${PROJECT} -o yaml > ${EXPORT_DIR}/${NAME}-deployment.yaml

DEPLOYMENT_YAML=${EXPORT_DIR}/${NAME}-deployment.yaml

if [ -s ${DEPLOYMENT_YAML} ]
then
  yq -i 'del(.metadata.namespace)' ${EXPORT_DIR}/${NAME}-deployment.yaml
  yq -i 'del(.metadata.uid)' ${EXPORT_DIR}/${NAME}-deployment.yaml
  yq -i 'del(.metadata.selfLink)' ${EXPORT_DIR}/${NAME}-deployment.yaml
  yq -i 'del(.metadata.creationTimestamp)' ${EXPORT_DIR}/${NAME}-deployment.yaml
  yq -i 'del(.metadata.resourceVersion)' ${EXPORT_DIR}/${NAME}-deployment.yaml
  yq -i 'del(.metadata.generation)' ${EXPORT_DIR}/${NAME}-deployment.yaml
  yq -i 'del(.metadata.managedFields)' ${EXPORT_DIR}/${NAME}-deployment.yaml
  yq -i 'del(.metadata.annotations)' ${EXPORT_DIR}/${NAME}-deployment.yaml
  yq -i 'del(.spec.template.spec.initContainers)' ${EXPORT_DIR}/${NAME}-deployment.yaml
  yq -i 'del(.spec.template.spec.containers[0].command)' ${EXPORT_DIR}/${NAME}-deployment.yaml
  yq -i 'del(.spec.template.spec.containers[0].args)' ${EXPORT_DIR}/${NAME}-deployment.yaml
  yq -i 'del(.spec.template.spec.containers[0].volumeMounts)' ${EXPORT_DIR}/${NAME}-deployment.yaml
  yq -i 'del(.spec.template.spec.containers[0].env)' ${EXPORT_DIR}/${NAME}-deployment.yaml
  yq -i 'del(.spec.template.spec.volumes)' ${EXPORT_DIR}/${NAME}-deployment.yaml
  yq -i 'del(.status)' ${EXPORT_DIR}/${NAME}-deployment.yaml
fi