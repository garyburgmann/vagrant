#!/usr/bin/env bash
sudo dnf update -y
sudo dnf upgrade -y
sudo dnf install -y podman git wget
# prepare container-related dev
sudo curl https://raw.githubusercontent.com/containers/podman-compose/devel/podman_compose.py -o /usr/local/bin/podman-compose 
sudo chmod +x /usr/local/bin/podman-compose
curl -fsSL https://get.docker.com | bash
sudo groupadd docker
sudo usermod -aG docker vagrant
sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
wget https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh -O /tmp/conda.sh
sudo chmod +x /tmp/conda.sh
/tmp/conda.sh -b -u -p $HOME/anaconda3
$HOME/anaconda3/bin/conda init
$HOME/anaconda3/bin/conda config --set auto_activate_base false
