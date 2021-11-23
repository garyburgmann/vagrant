#!/usr/bin/env bash
sudo dnf update -y
sudo dnf install -y docker-compose

curl -fsSL https://get.docker.com | bash
sudo groupadd docker
sudo usermod -aG docker vagrant
sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service
