    #!/bin/bash
    set -e
    #######################################################
    # Author    : Ahmet Önder Moğol
    #######################################################

echo __________________________ Step 1: Disable Swap on All Nodes __________________________
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo __________________________ Update __________________________
sudo apt-get update
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

echo __________________________ Docker Repository __________________________
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo __________________________ Add the repository to Apt sources:    
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo __________________________ Docker Repository __________________________
sudo apt-get update 
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

echo __________________________ Docker Service __________________________
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable docker
sudo systemctl status docker
sudo chmod 666 /var/run/docker.sock
docker version

echo __________________________ Kubernetes Repository __________________________

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo _______ This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list ________
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list


sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

kubeadm version
kubectl version
kubelet version

    #sudo systemctl enable --now kubelet
echo __________________________ Load Modules __________________________
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

    # Load modules
echo __________________________ Load Modules __________________________
sudo modprobe overlay
sudo modprobe br_netfilter

    # Setup required sysctl params, these persist across reboots.
echo _______ Setup required sysctl params, these persist across reboots. ______
sudo tee /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

echo __________________________ Apply sysctl params without reboot __________________________
    # Apply sysctl params without reboot
sudo sysctl --system

# Create a configuration file for containerd
echo __________________________ Create a configuration file for containerd __________________________
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

    # Restart containerd
echo __________________________ Restart containerd __________________________
sudo systemctl restart containerd
sudo systemctl enable containerd
sudo systemctl status containerd
