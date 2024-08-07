#!/bin/bash
set -e

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
kubectl get nodes
kubectl get pods -A

echo "Please wait a few minutes to get all pods running before joining any worker nodes."


kubectl get pods -n kube-system
kubectl get nodes -o wide
kubectl get pods --all-namespaces -o wide