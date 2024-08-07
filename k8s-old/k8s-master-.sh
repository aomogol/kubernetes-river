#!/bin/bash
set -e
#######################################################
# Author    : Ahmet Önder Moğol
#######################################################
echo __________________ Kubeadm Images Pull __________________
sudo kubeadm config images pull

echo __________________ Kubeadm Init __________________
#sudo kubeadm init 
sudo kubeadm init --control-plane-endpoint="master1.local:6443" --apiserver-advertise-address=192.168.1.201 --node-name k8smaster #--pod-network-cidr=192.168.100.0/24
#--pod-network-cidr=192.168.0.0/16
echo __________________ Kubeadm Admin Config __________________
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

nano kube-fhannel.yml 
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml     

echo ______ Calico Installation ______
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml       

echo ______________________ Kubectl Get Pods ______________________
kubectl get pods -n kube-system

echo ______________________ Kubectl Get Nodes ______________________
kubectl get nodes -o wide
echo ________________ Kubectl Get Pods All Namespaces _____________
kubectl get pods --all-namespaces -o wide
echo __________________________

