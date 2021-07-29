#!/usr/bin/env bash
sudo dnf update -y
sudo dnf upgrade -y
sudo dnf install -y podman podman-docker git wget
sudo curl https://raw.githubusercontent.com/containers/podman-compose/devel/podman_compose.py -o /usr/local/bin/podman-compose 
sudo chmod +x /usr/local/bin/podman-compose
wget https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh -O /tmp/conda.sh
sudo chmod +x /tmp/conda.sh
/tmp/conda.sh -b -u -p $HOME/anaconda3
$HOME/anaconda3/bin/conda init
$HOME/anaconda3/bin/conda config --set auto_activate_base false
