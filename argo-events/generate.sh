#!/usr/bin/env bash

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

helm template argo/argo-events \
  --name-template 'argo-events' \
  --namespace 'argo-events' \
  --values ./config.yaml \
  >> ./deployment.yaml
