#!/usr/bin/env bash

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo update

helm template stable/minio \
  --name-template 'dev' \
  --namespace 'minio' \
  --values ./config.yaml \
  > ./deployment.yaml
