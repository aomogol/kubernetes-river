# k8s-cluster









ev______

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:

  kubeadm join 192.168.1.201:6443 --token em9tlj.4m3cb535eig83vtk \
	--discovery-token-ca-cert-hash sha256:2016b1d72957db103413e9bcf19f8658b203657317f7e85801e498c0f917acba \
	--control-plane 

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.1.201:6443 --token em9tlj.4m3cb535eig83vtk \
	--discovery-token-ca-cert-hash sha256:2016b1d72957db103413e9bcf19f8658b203657317f7e85801e498c0f917acba 
5431""123