#!/bin/bash
set -e

sudo kubeadm init --control-plane-endpoint=192.168.1.201 --node-name k8smaster --pod-network-cidr=10.244.0.0/16
