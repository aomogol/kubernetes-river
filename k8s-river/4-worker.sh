#!/bin/bash
set -e

sudo kubeadm reset pre-flight checks

# sudsho + paste join cmd

# sample command
#  kubeadm join 172.27.5.14:6443 --token ocks85.u2sqfn330l36ypkc \
        #--discovery-token-ca-cert-hash #sha256:939be6a03f1a9014bfbb98507086e453fc83cd109319895871d27f9772653a1d \

# Be careful if there is --control-plane in join command means one more master node
sudo kubeadm join 192.168.1.201:6443 --token em9tlj.4m3cb535eig83vtk \
	--discovery-token-ca-cert-hash sha256:2016b1d72957db103413e9bcf19f8658b203657317f7e85801e498c0f917acba 