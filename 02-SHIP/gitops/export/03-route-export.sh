#!/bin/bash

PROJECT=$1
NAME=$2
EXPORT_DIR=$3

## Route
oc get route ${NAME} -n ${PROJECT} -o yaml > ${EXPORT_DIR}/${NAME}-route.yaml

ROUTE_YAML=${EXPORT_DIR}/${NAME}-route.yaml

if [ -s ${ROUTE_YAML} ]
then
  yq -i 'del(.metadata.namespace)' ${EXPORT_DIR}/${NAME}-route.yaml
  yq -i 'del(.metadata.annotations)' ${EXPORT_DIR}/${NAME}-route.yaml
  yq -i 'del(.metadata.uid)' ${EXPORT_DIR}/${NAME}-route.yaml
  yq -i 'del(.metadata.selfLink)' ${EXPORT_DIR}/${NAME}-route.yaml
  yq -i 'del(.metadata.creationTimestamp)' ${EXPORT_DIR}/${NAME}-route.yaml
  yq -i 'del(.metadata.resourceVersion)' ${EXPORT_DIR}/${NAME}-route.yaml
  yq -i 'del(.metadata.ownerReferences)' ${EXPORT_DIR}/${NAME}-route.yaml
  yq -i 'del(.metadata.managedFields)' ${EXPORT_DIR}/${NAME}-route.yaml
  yq -i 'del(.spec.host)' ${EXPORT_DIR}/${NAME}-route.yaml
  yq -i 'del(.status)' ${EXPORT_DIR}/${NAME}-route.yaml
fi