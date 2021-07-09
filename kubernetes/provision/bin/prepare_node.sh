# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports
sudo firewall-cmd --zone=public --permanent --add-port=10250/tcp
sudo firewall-cmd --zone=public --permanent --add-port=30000-32767/tcp
sudo firewall-cmd --reload

mkdir -p $HOME/.kube
CONFIG_DIR=/vagrant/provision
sudo cp -i $CONFIG_DIR/config $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo $CONFIG_DIR/join.sh
