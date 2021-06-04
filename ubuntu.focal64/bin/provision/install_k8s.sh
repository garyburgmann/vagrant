echo "preparing k8s"
# disable swap
swapoff -a
sed -i '/swap/d' /etc/fstab
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
NODENAME=$(hostname -s)
IPADDR=192.168.33.11
# https://github.com/flannel-io/flannel/blob/master/Documentation/kube-flannel.yml -> --pod-network-cidr=10.244.0.0/16
kubeadm init --apiserver-cert-extra-sans=$IPADDR --node-name $NODENAME --pod-network-cidr=10.244.0.0/16
sleep 30
# copy config for root
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
echo "alias kc=kubectl" >> $HOME/.bashrc
# copy config for vagrant
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config
echo "alias kc=kubectl" >> /home/vagrant/.bashrc
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
