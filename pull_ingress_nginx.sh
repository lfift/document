#!/bin/bash
set -e
yamls=(
configmap.yaml
namespace.yaml
rbac.yaml
tcp-services-configmap.yaml
with-rbac.yaml
udp-services-configmap.yaml
)
for yaml in ${yamls[@]}; do
 wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.20.0/deploy/$yaml
done
