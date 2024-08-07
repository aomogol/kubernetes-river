#!/bin/bash
set -e
#######################################################
# Author    : Ahmet Önder Moğol
#######################################################
# Kubernetes 1.30.2 Cluster Setup on Ubuntu 24.04
    # https://github.com/Aareez01/kubernetes-v1.30.2-cluster-using-kubeadm
    # https://www.youtube.com/watch?v=2XlI9qqed04

# Prerequisites
    # Ubuntu 22.04 LTS installed on all nodes.
    # Access to the internet.
    # User with sudo privileges.

# kubectl get pods -n kube-system
    kubectl get pods -n kube-system

# silinmesi gereken  bir pod var ise 
# kubectl delete pod -n kube-system <pod-name>

kubectl get nodes -o wide

# pod olusturma 
kubectl run nginx-pod-1 --image=nginx

# pod'i listeleme 
kubectl get pods -o wide

# pod'a service olusturma
kubectl expose pod nginx-pod-1 --port=8080 --target-port=80 --type=NodePort --name=nginx-service

# service'i listeleme
kubectl get svc

# service'e gelen istekleri izleme
kubectl port-forward svc/nginx-service 8080:80

