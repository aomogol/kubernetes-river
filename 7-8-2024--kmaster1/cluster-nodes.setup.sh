#!/bin/bash
set -e
#######################################################
# Author    : Ahmet Önder Moğol
#######################################################

## Kaynak
# Bu kaynak iyi
# https://github.com/LondheShubham153/kubestarter/blob/main/kubeadm_installation.md

# https://github.com/kubernetes/kubernetes
# https://dev.to/rahuldhole/kubernetes-cluster-setup-guide-2024-2d7l
# https://eviatargerzi.medium.com/installing-kubernetes-with-a-windows-node-a256f47ad85a
# https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
# https://kubernetes.io/blog/2023/08/15/pkgs-k8s-io-introduction/
# https://github.com/LondheShubham153/kubestarter/blob/main/minikube_installation.md
# https://github.com/kubernetes-sigs/sig-windows-tools/tree/master
# https://www.learnlinux.tv/how-to-build-an-awesome-kubernetes-cluster-using-proxmox-virtual-environment/
# https://cri-o.io/
# https://jqlang.github.io/jq/
#
#

sudo cp /etc/hosts /etc/hosts.bak
cat <<EOF | sudo tee -a /etc/hosts

192.168.1.206 kmaster1
192.168.1.207 knode1
EOF

# Create the .conf file to load the modules at bootup
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
sudo systemctl daemon-reload    

# using 'sudo su' is not a good practice.
sudo apt update -y
sudo apt-get install -y software-properties-common curl apt-transport-https ca-certificates gpg
sudo apt install docker.io -y
sudo usermod -aG docker $USER
sudo chmod 777 /var/run/docker.sock

# Update the Version if needed
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update && sudo apt install kubeadm kubectl kubelet -y
sudo apt-mark hold kubelet kubeadm kubectl



echo ""__  VM related setup__""
sudo apt install containerd
sudo mkdir /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
echo "Enabled SystemdCgroup in containerd default config"

sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
echo "IPv4 forwarding has been enabled. Bridging enabled!"

echo "br_netfilter" | sudo tee /etc/modules-load.d/k8s.conf > /dev/null
echo "br_netfilter has been added to /etc/modules-load.d/k8s.conf."

echo "__ SWAP OFF"
sudo swapoff -a
echo "Disabled swap"
echo "Edit /etc/fstab and disable swap if swap was eneabled"
sudo nano /etc/fstab


echo "__ Docker kontrol__"
docker ps -a


echo "__ Containerd"
systemctl status containerd

#sudo systemctl enable --now kubelet
#sudo systemctl start kubelet
sudo systemctl status kubelet

echo "Reboot the server."