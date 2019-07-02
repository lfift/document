#!/bin/bash
set -e
KUBE_VERSION=v1.15.0
KUBE_PAUSE_VERSION=3.1
ETCD_VERSION=3.3.10
DNS_VERSION=1.3.1
GCR_URL=k8s.gcr.io
MIRROR_KUBE_URL=mirrorgooglecontainers
MIRROR_DNS_URL=coredns
COREDNS_IMAGE=${MIRROR_DNS_URL}:${DNS_VERSION}
images=(
kube-proxy:${KUBE_VERSION}
kube-apiserver:${KUBE_VERSION}
kube-scheduler:${KUBE_VERSION}
kube-controller-manager:${KUBE_VERSION}
coredns:${DNS_VERSION}
etcd:${ETCD_VERSION}
pause:${KUBE_PAUSE_VERSION}
)
for imageName in ${images[@]};do
	if [[ $imageName != ${MIRROR_DNS_URL}:${DNS_VERSION} ]];then
		docker pull $MIRROR_KUBE_URL/$imageName
		docker image tag $MIRROR_KUBE_URL/$imageName $GCR_URL/$imageName
		docker image rm $MIRROR_KUBE_URL/$imageName
	else
		docker pull $MIRROR_DNS_URL/$imageName
                docker image tag $MIRROR_DNS_URL/$imageName $GCR_URL/$imageName
                docker image rm $MIRROR_DNS_URL/$imageName
	fi
done
