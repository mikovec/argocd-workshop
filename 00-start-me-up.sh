#!/bin/bash

set -e
set -x

# Start Kubernetes playground (when required)
: minikube start --memory=4096M --driver=virtualbox

# Install
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for application start
kubectl wait -n argocd --for=condition=ready pod/argocd-application-controller-0 --timeout=300s

# Show the password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

# Forward ArgoCD Web UI to localhost
kubectl port-forward svc/argocd-server -n argocd 8080:443

