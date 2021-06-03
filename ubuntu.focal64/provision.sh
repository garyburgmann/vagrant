export DEBIAN_FRONTEND=noninteractive
apt-get update
echo "upgrading system"
apt-get upgrade -y
apt-get autoremove -y
# disable swap
swapoff -a
sed -i '/swap/d' /etc/fstab
echo "preparing docker"
apt-get update && apt-get install -y curl
curl -fsSL https://get.docker.com | bash
usermod -aG docker vagrant
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
echo "preparing k8s"
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
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown $(id -u):$(id -g) /home/vagrant/.kube/config
echo "alias kc=kubectl" >> /home/vagrant/.bashrc
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl taint nodes --all node-role.kubernetes.io/master-
# export KUBECONFIG=/etc/kubernetes/admin.conf
# kubeadm token list
echo "preparing python"
apt-get update
apt-get install -y software-properties-common
add-apt-repository ppa:deadsnakes/ppa
apt-get update
apt-get install -y python3-pip python3-venv
apt-get install -y python3.7 python3.7-venv python3.7-doc
apt-get install -y python3.8 python3.8-venv python3.8-doc
apt-get install -y python3.9 python3.9-venv python3.9-doc
ln -s $(which python3.9) /usr/local/bin/python
ln -s $(which pip3) /usr/local/bin/pip
