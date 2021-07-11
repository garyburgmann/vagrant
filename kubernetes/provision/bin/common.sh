# https://medium.com/twodigits/install-kubernetes-1-21-1-on-centos-8-stream-include-fix-cap-perfmon-acf23a6879c6
sudo dnf update -y
sudo dnf upgrade -y

# use docker instead of cri-o
# curl -fsSL https://get.docker.com | bash
# sudo usermod -aG docker vagrant
# # https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker
# sudo mkdir /etc/docker
# cat <<EOF | sudo tee /etc/docker/daemon.json
# {
#   "exec-opts": ["native.cgroupdriver=systemd"],
#   "log-driver": "json-file",
#   "log-opts": {
#     "max-size": "100m"
#   },
#   "storage-driver": "overlay2"
# }
# EOF
# sudo systemctl enable --now docker

# use cri-o instead of docker

sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$CRI_OS/devel:kubic:libcontainers:stable.repo
sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:$CRI_VERSION.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$CRI_VERSION/$CRI_OS/devel:kubic:libcontainers:stable:cri-o:$CRI_VERSION.repo

# for both
sudo dnf install -y cri-o

# post install for both
sudo systemctl daemon-reload
sudo systemctl enable --now crio

sudo systemctl restart crio

sudo dnf install -y podman

sudo dnf upgrade -y

# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#cri-o
Create the .conf file to load the modules at bootup
cat <<EOF | sudo tee /etc/modules-load.d/crio.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

sudo dnf install -y firewalld
sudo systemctl enable --now firewalld

# Setup required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo firewall-cmd --add-masquerade --permanent
sudo firewall-cmd --reload

sudo sysctl --system

# disable swap
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab

# Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

sudo dnf install --disableexcludes=kubernetes -y {kubectl,kubeadm,kubelet}-${K8S_VERSION}

echo "KUBELET_EXTRA_ARGS=$KUBELET_EXTRA_ARGS" | sudo tee -a /etc/sysconfig/kubelet

sudo systemctl enable --now kubelet
sudo systemctl restart kubelet
