#!/usr/bin/env bash

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

INGRESS_HOST_VAR=$(cat config.yaml | grep -oP '(?<=INGRESS_HOST_VAR: ")(.*)(?=")')
MINIO_ACCESSKEY=$(cat config.yaml | grep -oP '(?<=MINIO_ACCESSKEY: ")(.*)(?=")' | base64)
MINIO_SECRETKEY=$(cat config.yaml | grep -oP '(?<=MINIO_SECRETKEY: ")(.*)(?=")' | base64)

# TODO: Little point in having crds separated.
# (but for now, hooks do not get saved into template..)
cat './_crd.yaml.tmpl' > ./deployment.yaml
cat './_default_rb.yaml.tmpl' >> ./deployment.yaml
cat './_dev-minio.secret.yaml.tmpl' \
  | sed --expression="s/{{MINIO_ACCESSKEY}}/${MINIO_ACCESSKEY}/g" \
  | sed --expression="s/{{MINIO_SECRETKEY}}/${MINIO_SECRETKEY}/g" \
  >> ./deployment.yaml
sed "s/{{INGRESS_HOST_VAR}}/${INGRESS_HOST_VAR}/g" './_ingress.yaml.tmpl' \
  >> ./deployment.yaml

helm template argo/argo \
  --name-template 'argo' \
  --namespace 'argo' \
  --values ./config.yaml \
  >> ./deployment.yaml
