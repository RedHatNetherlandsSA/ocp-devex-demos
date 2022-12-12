#!/bin/bash

PROJECT=$1
NAME=$2
EXPORT_DIR=$3

## Service
oc get svc ${NAME} -n ${PROJECT} -o yaml > ${EXPORT_DIR}/${NAME}-service.yaml

SERVICE_YAML=${EXPORT_DIR}/${NAME}-service.yaml

#yq -i 'del(.metadata.namespace)' ./tmp/dotnet-demo-service.yaml

if [ -s ${SERVICE_YAML} ]
then
  yq -i 'del(.metadata.namespace)' ${EXPORT_DIR}/${NAME}-service.yaml
  yq -i 'del(.metadata.annotations)' ${EXPORT_DIR}/${NAME}-service.yaml
  yq -i 'del(.metadata.uid)' ${EXPORT_DIR}/${NAME}-service.yaml
  yq -i 'del(.metadata.selfLink)' ${EXPORT_DIR}/${NAME}-service.yaml
  yq -i 'del(.metadata.creationTimestamp)' ${EXPORT_DIR}/${NAME}-service.yaml
  yq -i 'del(.metadata.resourceVersion)' ${EXPORT_DIR}/${NAME}-service.yaml
  yq -i 'del(.metadata.ownerReferences)' ${EXPORT_DIR}/${NAME}-service.yaml
  yq -i 'del(.metadata.managedFields)' ${EXPORT_DIR}/${NAME}-service.yaml
  yq -i 'del(.metadata.clusterIP)' ${EXPORT_DIR}/${NAME}-service.yaml
  yq -i 'del(.metadata.clusterIPs)' ${EXPORT_DIR}/${NAME}-service.yaml
  # Specific changes for Staging Environment with Istio
  yq -i 'del(.spec.selector)' ${EXPORT_DIR}/${NAME}-service.yaml
  yq -i 'del(.spec.selector.app)' ${EXPORT_DIR}/${NAME}-service.yaml
  yq -i 'del(.metadata.labels.app)' ${EXPORT_DIR}/${NAME}-service.yaml
fi