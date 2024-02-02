#!/bin/bash

# set context to application-cluster
KUBE_CONTEXT="kind-application-cluster"
kubectl config use-context "$KUBE_CONTEXT"

# create rook-ceph  namespace if not present
ROOK_CEPH_NAMESPACE="rook-ceph"
kubectl get ns "$ROOK_CEPH_NAMESPACE" || kubectl create ns "$ROOK_CEPH_NAMESPACE"

# install OLM
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.26.0/install.sh | bash -s v0.26.0

# deploy rook-ceph operator from operatorhub manifests
echo "deploy rook-ceph operator..."
kubectl create -f https://operatorhub.io/install/rook-ceph.yaml

# deploy mongodb crds
kubectl apply -f configs/ceph-cluster.yaml -n "$ROOK_CEPH_NAMESPACE"
kubectl apply -f configs/ceph-object-store.yaml -n "$ROOK_CEPH_NAMESPACE"

echo "Rook-Ceph and CRDs deployed successfully in namespace '$ROOK_CEPH_NAMESPACE' of context '$KUBE_CONTEXT'."