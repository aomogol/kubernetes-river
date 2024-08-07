#!/bin/bash
set -e
#######################################################
# Author    : Ahmet Önder Moğol
#######################################################



#sudo kubeadm join <master-node-ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
echo ______ Kubeadm Join _________________

sudo kubeadm join 192.168.1.201:6443 --token i84v4m.3uun13qfeclwyk7d \
	--discovery-token-ca-cert-hash sha256:14f2ea9ba13d1ba4981e45da889b409c171658931a9bb79c6010baa2c325534f 
