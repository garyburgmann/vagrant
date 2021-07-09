# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports
sudo firewall-cmd --zone=public --permanent --add-port={6443,2379,2380,10250,10251,10252}/tcp
sudo firewall-cmd --zone=public --permanent --add-rich-rule 'rule family=ipv4 source address=172.17.0.0/16 accept'
sudo firewall-cmd --reload

sudo kubeadm config images pull
# https://github.com/flannel-io/flannel/blob/master/Documentation/kube-flannel.yml -> --pod-network-cidr=10.244.0.0/16
sudo kubeadm init --apiserver-advertise-address $IPADDR --apiserver-cert-extra-sans $IPADDR --node-name $NAME --pod-network-cidr $POD_NETWORK_CIDR

CONFIG_DIR=/vagrant/provision
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo cp /etc/kubernetes/admin.conf $CONFIG_DIR/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config $CONFIG_DIR/config

sudo kubeadm token create --print-join-command > $CONFIG_DIR/join.sh
sudo chmod +x $CONFIG_DIR/join.sh

# kubectl taint nodes --all node-role.kubernetes.io/master-

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# kubectl create -f https://docs.projectcalico.org/manifests/calico.yaml

# kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
